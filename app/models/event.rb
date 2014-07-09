class Event < ActiveRecord::Base
  include EasternTime, ModelConfig, ItemReview, WeeklyOutput

  before_validation :set_month_day
  before_validation :sanitize

  has_paper_trail

  validates :event, presence: true, length: { in: 25..150 }, uniqueness: true
  validates :date, :link, presence: true, uniqueness: true
  validates_date :date, on_or_before: :today
  validates_formatting_of :link, using: :url
  validates :month_day, presence: true

  rails_admin do
    navigation_label 'Daily Items'
    label 'Historical Event'
    list do
      sort_by 'status_order_by, month_day, date'
      items_per_page 500
      include_fields :date, :event, :creator
      configure :date do
        strftime_format '%m/%d/%Y'
        column_width 75
        sortable :month_day
      end
      field :status_with_color do
        label 'Status'
        column_width 85
      end
      configure :creator do
        column_width 85
      end
    end

    edit do
      include_fields :event, :link, :date, :reviewed, :needs_work do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      configure :event do
        help ('Required. Between 40 and 150 characters. '\
              'There are a few ways to tackle a historical event.<br>'\
              '<b>1. The way it\'s phrased:</b><br>'\
              '"Current U.S. President Bill Clinton does not have '\
              'sexual relations with that woman for the first time."<br>'\
              '<b>2. Random joke at the end because you can\'t think of '\
              'anything:</b><br>'\
              '"Mahatma Gandhi begins his final fast for the Indian '\
              'independence. Hunger, more like shmunger."<br>'\
              '<b>3. No joke necessary, because it’s just so goddamn '\
              'dudefest:</b><br>'\
              '"Mountaineer Aron Ralston cuts off his own arm to free '\
              'himself from a canyon in Blue John Canyon in Utah after '\
              'being trapped under a boulder for five days."<br>'\
              '<b>4. Effect of the event:</b><br>'\
              '"Women\'s Beach Volleyball debuts as an Olympic Sport in '\
              'Atlanta. The bikini is finally recognized as athletic wear."')
             .html_safe
      end
      configure :link do
        help 'Required. Make sure the link has enough content to read, '\
             'but mentions the event.'
      end
      include_fields :notes
      configure :date do
        help 'Required. Enter date as YYYY-MM-DD.'
        date_format :default
      end
      configure :needs_work do
        visible do
          bindings[:object].failable?
        end
      end
      configure :reviewed do
        visible do
          bindings[:object].reviewable?
        end
      end
      field :weekly_output do
        read_only true
        help 'Logging your historical event entry here makes it an historical '\
             'event in and of itself. Word.'
      end
    end

    show do
      include_fields :event, :link, :date, :creator
    end
  end

  public
    def label
      self.event
    end

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

    def sanitize
      Sanitize.clean!(self.event)
      Sanitize.clean!(self.link)
    end
end
