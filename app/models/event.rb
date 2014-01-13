class Event < ActiveRecord::Base
  include EasternTime, ModelConfig, ItemReview

  before_validation :set_month_day

  validates :event, presence: true, length: { in: 40..150 }, uniqueness: true
  validates :date, :link, presence: true, uniqueness: true
  validates_date :date, on_or_before: :today
  validates_formatting_of :link, using: :url
  validates :month_day, presence: true

  rails_admin do
    navigation_label 'Daily Items'
    label 'Historical Event'
    list do
      sort_by :date
      items_per_page 500
      include_fields :date, :event, :creator, :reviewed
      configure :date do
        strftime_format '%m/%d/%Y'
        sortable :month_day
        sort_reverse :false
      end
    end

    edit do
      include_fields :event, :link, :date, :reviewed do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      include_fields :notes
      configure :date do
        help 'Required. Enter date as YYYY-MM-DD'
        date_format :default
        strftime_format '%m/%d/%y'
      end
      configure :reviewed do
        visible do
          bindings[:object].reviewable?
        end
      end
    end

    show do
      include_fields :event, :link, :date, :creator
    end
  end

  public
    def year_str
      self.date.year.to_s + ': '
    end

    def self.this_day
      where(month_day: find_month_day(self.today_est), reviewed: true)
        .order(date: :desc)
    end

  private
    def self.find_month_day(given_date)
      given_date.month * 100 + given_date.day
    end

    def set_month_day
      self.month_day = self.class.find_month_day(self.date)
    end
end
