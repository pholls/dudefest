class Quote < ActiveRecord::Base
  include EasternTime, ModelConfig, ItemReview, DailyItem

  before_validation :sanitize

  has_paper_trail
  belongs_to :dude, inverse_of: :quotes, counter_cache: true

  validates :quote, presence: true, length: { in: 8..500 }, uniqueness: true
  validates_associated :dude, allow_blank: true
  validates :context, length: { in: 0..100 }, allow_blank: true
  validates :year, numericality: { only_integer: true, less_than: 2015 },
                   allow_blank: true
  validates_formatting_of :source, using: :url
  validates :source, presence: true

  rails_admin do
    object_label_method :quote
    navigation_label 'Daily Items'

    list do
      sort_by 'date desc, reviewed, creator_id, created_at'
      include_fields :date, :dude, :quote, :creator, :reviewed
      configure :date do
        strftime_format '%Y-%m-%d'
        column_width 75
      end
      configure :reviewed do
        column_width 75
      end
      configure :creator do
        column_width 85
      end
      configure :dude do
        column_width 130
      end
    end

    edit do
      include_fields :dude, :quote, :context, :source, :year, :reviewed,
                     :published do
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
    end
  end

  def display_attribution
    display = self.dude.name if self.dude.present?
    display += ' ' + self.context if self.context.present?
    display += ', ' + self.year if self.year.present?
    display
  end

  private
    def sanitize
      Sanitize.clean!(self.quote) 
      Sanitize.clean!(self.context) if self.context.present?
      Sanitize.clean!(self.source) 
    end
end
