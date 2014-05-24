module ColumnSchedule
  extend ActiveSupport::Concern

  included do 
    validate :can_be_published
  end

  public
    def set_editor
      User.with_role(:editor).where.not(id: User.current.id)
          .min_by { |u| u.edited_articles.where(status_order_by: [1, 3]).count }
    end

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

    def can_be_published
      if self.published? && self.date_changed?
        new_date = self.date || assign_date()
        start_of_week = new_date.beginning_of_week(:sunday)

        # make sure writer has no other articles coming out on that day
        if Article.where(date: new_date, creator: self.creator)
                  .where.not(id: self.id).count > 0
          errors.add(:published, 'creator can\'t have > 1 article in a day')
        end

        # make sure writer has < 4 articles this week
        if Article.where(date: start_of_week..new_date.end_of_week(:sunday))
                  .where.not(id: self.id).count > 2
          errors.add(:published, 'creator can\'t have > 3 articles in a week')
        end
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

