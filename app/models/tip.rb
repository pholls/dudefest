class Tip < ApplicationRecord
  include EasternTime, ModelConfig, ItemReview, DailyItem, WeeklyOutput

  before_validation :sanitize

  has_paper_trail

  validates :tip, presence: true, uniqueness: true, length: { in: 10..200 }

  rails_admin do
    label 'Just the Tip'

    list do
      include_fields :date, :tip, :creator, :status_with_color
      configure :tip do
        label 'Just the Tip'
      end
    end

    edit do
      include_fields :tip do
        label 'Put your tip in'
        read_only { is_read_only? }
        help { object.tip_help }
      end
      include_fields :reviewed, :needs_work, :published, :notes, :weekly_output
      field :current_user_id
    end
  end

  def label
    self.tip
  end

  def tip_help
    ('<ul><li>Between 10 and 200 characters.</li>'\
     '<li>Keep the tips short and sweet.</li><li>A piece of advice or a '\
     'question leading off makes them very strong.</li><li>Follow it '\
     'with no more than two sentences to '\
     'explain how to achieve the desired outcome.</li></ul>').html_safe
  end

  def weekly_output_help
    'It\'s another place to put your tip in.'
  end

  private
    def sanitize
      self.tip = Sanitize.fragment(self.tip)
    end
end
