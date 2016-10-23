class Fact < ApplicationRecord
  include EasternTime, ModelConfig, ItemReview

  TYPES = ['fact', 'statistic']

  has_paper_trail

  validates :fact, presence: true, uniqueness: true
  validates :nickname, presence: true
  validates :type, presence: true, inclusion: { in: TYPES }

  rails_admin do
    navigation_label 'Kennedy Research Center'

    list do
      sort_by 'status_order_by, reviewed_at desc, created_at, fact'
      include_fields :fact, :nickname, :type, :status_with_color
      configure :type do
        column_width 100
      end
      configure :nickname do
        column_width 110
      end
    end

    edit do
      include_fields :fact, :nickname, :type do
        read_only { is_read_only? }
      end
      include_fields :reviewed, :needs_work, :notes, :current_user_id
    end
  end

  def label
    self.fact
  end

  def type_enum; TYPES; end
end
