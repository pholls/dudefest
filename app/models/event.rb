class Event < ActiveRecord::Base
  include ModelConfig, ItemReview

  validates :event, presence: true, length: { in: 40..125 }, uniqueness: true
  validates :date, :link, presence: true, uniqueness: true
  validates_date :date, on_or_before: :today
  validates_formatting_of :link, using: :url

  rails_admin do
    navigation_label 'Daily Items'
    label 'Historical Event'
    list do
      sort_by :date, :created_at
      include_fields :date, :event, :creator, :reviewed
      configure :date do
        strftime_format '%Y-%m-%d'
      end
    end

    edit do
      include_fields :event, :link, :date, :reviewed do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      include_fields :notes
      configure :reviewed do
        visible do
          bindings[:object].reviewable?
        end
      end
    end

    show do
      include_fields :event, :link, :creator
    end
  end

  public
    def year_str
      self.date.year.to_s + ': '
    end

    def self.this_day
      # Commenting this out for test purposes. This must change!
      # where('EXTRACT(MONTH FROM DATE) = ? AND EXTRACT(DAY FROM DATE) = ?',
      #       Date.today.month, Date.today.day).order(date: :desc)
      order(date: :desc)
    end
end
