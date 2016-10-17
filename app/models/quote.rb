class Quote < ApplicationRecord
  include EasternTime, ModelConfig, ItemReview, DailyItem, WeeklyOutput

  before_validation :sanitize

  has_paper_trail
  belongs_to :dude, inverse_of: :quotes, counter_cache: true

  validates :quote, presence: true, length: { in: 8..500 }, uniqueness: true
  validates_associated :dude, allow_blank: true
  validates :context, length: { in: 0..100 }, allow_blank: true
  validates :year, numericality: { only_integer: true, less_than: 2015 },
                   allow_blank: true
  validates :source, presence: true
  validates_formatting_of :source, using: :url

  rails_admin do
    object_label_method :quote
    navigation_label 'Daily Items'

    list do
      sort_by 'date desc, status_order_by, creator_id, created_at'
      include_fields :date, :dude, :quote, :creator
      configure :date do
        strftime_format '%Y-%m-%d'
        column_width 85
      end
      field :status_with_color do
        label 'Status'
        sortable :status_order_by
        searchable :status
        column_width 95
      end
      configure :creator do
        column_width 90
      end
      configure :dude do
        column_width 130
      end
    end

    edit do
      include_fields :dude, :quote, :context, :source, :year, :reviewed,
                     :needs_work, :published do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      configure :quote do
        help 'Required. Between 8 and 500 characters.'\
             'Try and make it funny dudes.'\
      end
      configure :context do
        help ('Optional. At most 100 characters.<br>'\
              'Use context to enhance the quote if possible.<br>'\
              'The Ryan Leaf quote is an example of context.').html_safe
      end
      configure :source do
        help 'Optional. Length up to 255. Helps verify the link.'
      end
      include_fields :notes
      configure :needs_work do
        visible do
          bindings[:object].failable?
        end
      end
      configure :reviewed do
        visible do
          bindings[:object].reviewable? && !bindings[:object].reviewed?
        end
      end
      configure :published do
        visible do
          bindings[:object].reviewed? 
        end
      end
      field :weekly_output do
        read_only true
        help 'Just do it. Ya dick.'
      end
    end
  end

  def label
    self.quote ? '"' + self.quote + '"' : nil
  end

  def display_attribution
    [self.dude.name, self.context, self.year.to_s].reject(&:blank?).join(', ')
  end

  private
    def sanitize
      self.quote   = Sanitize.fragment(self.quote) 
      self.context = Sanitize.fragment(self.context) if self.context.present?
      self.source  = Sanitize.fragment(self.source) 
    end
end
