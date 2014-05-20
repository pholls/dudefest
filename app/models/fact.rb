class Fact < ActiveRecord::Base
  include EasternTime, ModelConfig, ItemReview

  TYPES = ['fact', 'statistic']

  has_paper_trail

  validates :fact, presence: true, uniqueness: true
  validates :nickname, presence: true
  validates :type, presence: true, inclusion: { in: TYPES }

  rails_admin do
    navigation_label 'Kennedy Research Center'
    list do
      sort_by 'reviewed_at desc, reviewed, created_at, fact'
      include_fields :fact, :nickname, :type, :reviewed
      configure :reviewed do
        column_width 75
      end
      configure :type do
        column_width 100
      end
      configure :nickname do
        column_width 110
      end
    end

    edit do
      include_fields :fact, :nickname, :type, :reviewed do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      field :notes
      configure :reviewed do
        visible do
          bindings[:object].reviewable?
        end
      end
    end
  end

  def type_enum
    ['statistic', 'fact']
  end
end
