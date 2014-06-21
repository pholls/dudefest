class Tip < ActiveRecord::Base
  include EasternTime, ModelConfig, ItemReview, DailyItem, WeeklyOutput

  before_validation :sanitize

  has_paper_trail

  validates :tip, presence: true, uniqueness: true, length: { in: 10..200 }

  rails_admin do
    label 'Just the Tip'
    navigation_label 'Daily Items'
    list do
      sort_by 'date desc, status_order_by, creator_id, created_at'
      include_fields :date, :tip, :creator
      configure :date do
        strftime_format '%Y-%m-%d'
        column_width 75
      end
      configure :tip do
        label 'Just the Tip'
      end
      field :status_with_color do
        column_width 90
        label 'Status'
      end
      configure :creator do
        column_width 85
      end
    end

    edit do
      include_fields :tip, :reviewed, :needs_work, :published do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      include_fields :notes
      configure :tip do
        label 'Put your tip in'
        help do 
          bindings[:object].tip_help
        end
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

  def tip_help
    ('<ul><li>Between 10 and 200 characters.</li>'\
     '<li>Keep the tips short and sweet.</li><li>A piece of advice or a '\
     'question leading off makes them very strong.</li><li>Follow it '\
     'with no more than two sentences to '\
     'explain how to achieve the desired outcome.</li></ul>').html_safe
  end

  private
    def sanitize
      Sanitize.clean!(self.tip)
    end
end
