module EasternTime
  extend ActiveSupport::Concern

  public
    def now_est
      self.class.now_est
    end

    def today_est
      self.class.today_est
    end

  module ClassMethods
    def now_est
      tz = 'Eastern Time (US & Canada)'
      DateTime.now.in_time_zone(tz)
    end

    def today_est
      self.now_est.to_date
    end
  end
end
