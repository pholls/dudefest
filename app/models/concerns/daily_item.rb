module DailyItem
  extend ActiveSupport::Concern

  included do
    after_initialize :set_published
    validates :date, allow_blank: :true, uniqueness: true, on: :update

    rails_admin do
      configure :date do
        strftime_format '%Y-%m-%d'
        column_width 85
      end
      configure :published do
        visible   { bindings[:object].reviewed? }
        read_only { is_read_only? }
      end

      list do
        sort_by 'date desc, status_order_by, creator_id, created_at'
      end
    end
  end

  private
    def set_date
      if self.published? && self.date.nil?
        if self.class.select(:date).count > 0
          self.class.maximum(:date) + 1.day
        else
          self.class.start_date
        end
      end
    end

    def set_published
      self.published = false if self.published.nil?
    end

  module ClassMethods
    def of_the_day
      item = self.find_by(date: self.today_est)

      return item if item

      total_items = self.where.not(date: nil).count
      first_item = self.where.not(date: nil).order(date: :asc).first

      return nil if first_item.nil?

      date_diff = (self.today_est - first_item.date).to_i
      date_to_use = first_item.date + (date_diff % total_items).days

      return self.find_by(date: date_to_use)
    end

    def random_live(x)
      where('date <= ?', self.today_est).order('RANDOM()').limit(x)
    end
  end
end
