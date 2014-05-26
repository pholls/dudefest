class Tip < ActiveRecord::Base
  include EasternTime, ModelConfig, ItemReview, DailyItem, WeeklyOutput

  before_validation :sanitize

  has_paper_trail

  validates :tip, presence: true, uniqueness: true, length: { in: 10..200 }

  rails_admin do
    label 'Just the Tip'
    navigation_label 'Daily Items'
    list do
      sort_by 'date desc, reviewed, creator_id, created_at'
      include_fields :date, :tip, :creator, :reviewed
      configure :date do
        strftime_format '%Y-%m-%d'
        column_width 75
      end
      configure :tip do
        label 'Just the Tip'
      end
      configure :reviewed do
        column_width 75
      end
      configure :creator do
        column_width 85
      end
    end

    edit do
      include_fields :tip, :reviewed, :published do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      include_fields :notes
      configure :tip do
        label 'Put your tip in'
        help do 
          tip_help
        end
      end
      configure :reviewed do
        visible do
          bindings[:object].reviewable? && !bindings[:object].reviewed?
        end
      end
      configure :published do
        visible do
          bindings[:object].reviewed?
        end
      end
      field :weekly_output do
        read_only true
        help 'It\'s another place to put your tip in.'
      end
    end
  end

  private
    def sanitize
      Sanitize.clean!(self.tip)
    end

    def tip_help
      ('Required. Between 10 and 200 characters.<br>'\
       'Keep the tips short and sweet.<br>A piece of advice or a '\
       'question leading off makes them very strong.<br>Follow it '\
       'with no more than two sentences to '\
       'explain how to achieve the desired outcome.').html_safe
    end
end
