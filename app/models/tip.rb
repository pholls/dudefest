class Tip < ActiveRecord::Base
  after_create :set_date

  validates :tip, presence: true, length: { in: 30..200 }, uniqueness: true
  validates :date, presence: true, uniqueness: true, on: :save

  public
    def self.of_the_day
      self.where(date: Date.today).first
    end

  private
    def set_date
      if self.class.count > 1
        self.update_attributes(date: self.class.maximum(:date) + 1.days)
      else
        self.update_attributes(date: Date.today)
      end
    end

end
