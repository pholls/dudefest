module DailyItem
  extend ActiveSupport::Concern

  included do 
    before_validation :set_date
    validates :date, allow_blank: :true, uniqueness: true, on: :update
  end

  private
    def set_date
      if self.published? && self.date.nil?
        if self.class.select(:date).count > 0
          self.date = self.class.maximum(:date) + 1.day
        else
          self.date = self.class.start_date
        end
      end
    end

  module ClassMethods
    def of_the_day
      if Rails.env.production?
        where(date: self.today_est).first
      else
        where.not(date: nil).first
      end
    end

    def random_live(x)
      where('date <= ?', self.today_est).order('RANDOM()').limit(x)
    end
  end
end
