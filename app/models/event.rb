class Event < ActiveRecord::Base
  include ItemReview

  validates :event, presence: true, length: { in: 40..125 }, uniqueness: true
  validates :date, :link, presence: true, uniqueness: true
  validates_date :date, on_or_before: :today
  validates_formatting_of :link, using: :url

  rails_admin do
    navigation_label 'Daily Items'
    list do
      sort_by :date, :created_at
      field :date do
        strftime_format '%Y-%m-%d'
      end
      field :event
      field :creator
      field :reviewed
    end

    edit do
      field :event
      field :link
      field :date
      field :reviewed do
        visible do
          bindings[:object].reviewable?
        end
      end
    end

    show do
      field :event
      field :link
      field :creator
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
