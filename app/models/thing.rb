class Thing < ActiveRecord::Base
  include ModelConfig, ItemReview, DailyItem

  belongs_to :thing_category

  validates :thing, presence: true, length: { in: 3..32 }, uniqueness: true
  validates :image, presence: true, uniqueness: true
  validates_formatting_of :image, using: :url
  validates :image, format: { with: /\.(png|jpg|jpeg|)\z/,
                              message: 'must be .png, .jpg, or .jpeg' }
  validates :description, presence: true, length: { in: 150..500}, 
                          uniqueness: true
  validates :thing_category, presence: true

  auto_html_for :image do
    html_escape
    image
  end

  rails_admin do
    object_label_method :thing
    navigation_label 'Daily Items'
    configure :thing_category do
      label 'Category'
    end

    list do
      sort_by :date, :created_at
      include_fields :date, :thing, :thing_category, :creator, :reviewed
      configure :date do
        strftime_format '%Y-%m-%d'
      end
    end

    edit do
      include_fields :thing_category, :thing, :image, :description, :reviewed do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      include_fields :notes
      configure :image do
        label 'Image URL'
        help 'Required. Use an image url here.'
      end
      configure :reviewed do
        visible do
          bindings[:object].reviewable?
        end
      end
    end

    show do
      include_fields :thing_category, :thing
      field :image_html
      include_fields :description, :creator
    end
  end
  
  public
    def category
      self.thing_category.category
    end
end
