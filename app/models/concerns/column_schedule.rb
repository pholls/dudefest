module ColumnSchedule
  extend ActiveSupport::Concern

  included do 
  end

  public
    def assign_date
      max_date = self.class.where(column: self.column).maximum(:date)
      if max_date.nil?
        self.date = self.column.start_date
      else
        wday = (max_date.wday + 1).to_s
        days = self.column.publish_days

        days.split(//).each_with_index do |day, i|
          if day == wday
            return next_date(max_date, days[(i + 1) % days.length].to_i - 1)
          end
        end

        next_date(max_date, days[0].to_i - 1)
      end
    end 

  private
    def next_date(a_date, day)
      if day > a_date.wday
        a_date + (day - a_date.wday) 
      else
        a_date.next_week.yesterday.next_day(day)
      end
    end

  module ClassMethods
  end
end

