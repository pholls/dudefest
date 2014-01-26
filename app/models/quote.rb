class Quote < ActiveRecord::Base
  include EasternTime, ModelConfig, ItemReview, DailyItem

  belongs_to :dude, inverse_of: :quotes, counter_cache: true

  validates :quote, presence: true, length: { in: 20..500 }, uniqueness: true
  validates_associated :dude, allow_blank: true
  validates :context, length: { in: 0..100 }, allow_blank: true
  validates :year, numericality: { only_integer: true, less_than: 2015 },
                   allow_blank: true
  validates_formatting_of :source, using: :url, allow_blank: true 

  rails_admin do
    object_label_method :quote
    navigation_label 'Daily Items'

    list do
      sort_by 'date, reviewed, created_at'
      include_fields :date, :dude, :quote, :creator, :reviewed
      configure :date do
        strftime_format '%Y-%m-%d'
        column_width 75
      end
      configure :reviewed do
        column_width 75
      end
    end

    edit do
      include_fields :dude, :quote, :context, :source, :year, :reviewed,
                     :published do
        read_only do
          bindings[:object].is_read_only?
        end
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
    display = self.dude.name 
    display += ' ' + self.context if self.context.present?
    display += ', ' + self.year if self.year.present?
    display
  end
end
