class Position < ActiveRecord::Base
  include ItemReview, DailyItem

  validates :position, presence: true, length: { in: 3..32 }, uniqueness: true
  validates :description, presence: true, length: { in: 100..500 }, 
                          uniqueness: true
  validates :image, presence: true, uniqueness: true
  validates_formatting_of :image, using: :url
  validates :image, format: { with: /\.(png|jpg|jpeg|)\z/,
                              message: 'must be .png, .jpg, or .jpeg' }

  auto_html_for :image do
    html_escape
    image
  end

  rails_admin do
    object_label_method :position
    navigation_label 'Daily Items'
    list do
      sort_by :date, :created_at
      field :date do
        strftime_format '%Y-%m-%d'
      end
      field :position
      field :creator
      field :reviewed
    end

    edit do
      field :position
      field :description
      field :image
      field :reviewed do
        visible do
          bindings[:object].reviewable?
        end
      end
    end

    show do
      field :position
      field :description
      field :image_html
      field :creator
    end
  end
end
