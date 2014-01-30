class Thing < ActiveRecord::Base
  include EasternTime, ModelConfig, ItemReview, DailyItem

  before_validation :sanitize

  belongs_to :thing_category, inverse_of: :things

  validates :thing, presence: true, length: { in: 3..26 }, uniqueness: true
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
      column_width 120
    end

    list do
      sort_by 'date, reviewed, created_at'
      include_fields :date, :thing_category, :thing, :creator, :reviewed
      configure :date do
        strftime_format '%Y-%m-%d'
        column_width 75
      end
      configure :reviewed do
        column_width 75
      end
    end

    edit do
      include_fields :thing_category, :thing, :description, :image, 
                     :published, :reviewed do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      field :image_html do
        label 'Image'
        read_only true
        visible false
        help false
      end
      include_fields :notes
      configure :image do
        label 'Image URL'
        help 'Required. Use an image url here.'
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
    end

    update do
      field :image_html do
        visible true
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

  private
    def sanitize
      Sanitize.clean!(self.thing)
      Sanitize.clean!(self.description)
      Sanitize.clean!(self.image)
    end
end
