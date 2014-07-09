class Tagline < ActiveRecord::Base
  include ModelConfig, ItemReview

  has_paper_trail

  validates :tagline, presence: true, uniqueness: true

  rails_admin do
    navigation_label 'Daily Items'
    object_label_method :tagline
    list do
      sort_by 'status_order_by, tagline, created_at'
      include_fields :tagline, :creator
      field :status_with_color do
        label 'Status'
        column_width 90
      end
      configure :creator do
        column_width 85
      end
    end

    edit do
      include_fields :tagline, :reviewed, :needs_work do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      configure :tagline do
        help 'Required. If it\'s not funny, then Dylan will literally kill '\
             'you.'
      end
      field :notes
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
    end

    show do
      include_fields :tagline, :creator, :reviewed
    end
  end

  def label
    self.tagline
  end
end
