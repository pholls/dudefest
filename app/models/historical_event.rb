class HistoricalEvent < ActiveRecord::Base
  validates :event, presence: true, length: { in: 40..175 }, uniqueness: true
  validates :date, :link, presence: true, uniqueness: true
  validates_date :date, on_or_before: :today
  validates_formatting_of :link, using: :url

  public
    def year_str
      self.date.year.to_s + ': '
    end

    def self.this_day
      self.where('EXTRACT(MONTH FROM DATE) = ? AND EXTRACT(DAY FROM DATE) = ?',
                 Date.today.month, Date.today.day).order(date: :desc)
    end

end
