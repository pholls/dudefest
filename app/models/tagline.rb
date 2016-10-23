class Tagline < ApplicationRecord
  include ModelConfig, ItemReview

  has_paper_trail

  validates :tagline, presence: true, uniqueness: true

  rails_admin do
    object_label_method :tagline

    list do
      sort_by 'status_order_by, tagline, created_at'
      include_fields :tagline, :creator, :status_with_color
    end

    edit do
      field :tagline do
        read_only { is_read_only? }
        help "Required. If it's not funny, then Dylan will literally kill you."
      end
      include_fields :reviewed, :needs_work, :notes, :current_user_id
    end

    show do
      include_fields :tagline, :creator, :reviewed
    end
  end

  def label
    self.tagline
  end
end
