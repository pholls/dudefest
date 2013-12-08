module DailyItem
  extend ActiveSupport::Concern

  included do 
    before_validation :set_date
    validates :date, allow_blank: :true, uniqueness: true, on: :update
  end

  private
    def set_date
      if self.reviewed?
        if self.class.select(:date).count > 0
          self.date = self.class.maximum(:date) + 1.day
        else
          self.date = Date.today
        end
      end
    end

  module ClassMethods
    def of_the_day
      # This is commented out because it's easier to test. THIS MUST CHANGE
      # where(date: Date.today).first
      order(date: :desc).first
    end
  end

end
