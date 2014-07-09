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
      sort_by 'status_order_by, reviewed_at desc, created_at, fact'
      include_fields :fact, :nickname, :type
      field :status_with_color do
        label 'Status'
        sortable :status_order_by
        searchable :status
        column_width 85
      end
      configure :type do
        column_width 100
      end
      configure :nickname do
        column_width 110
      end
    end

    edit do
      include_fields :fact, :nickname, :type, :reviewed, :needs_work do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      include_fields :needs_work do
        visible do
          bindings[:object].failable?
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

  def label
    self.fact
  end

  def type_enum; TYPES; end
end
