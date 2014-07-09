class Position < ActiveRecord::Base
  include EasternTime, ModelConfig, ItemReview, DailyItem

  before_validation :sanitize

  has_paper_trail

  validates :position, presence: true, length: { in: 3..32 }, uniqueness: true
  validates :description, presence: true, length: { in: 45..500 }, 
                          uniqueness: true
  validates :image, uniqueness: true, allow_blank: true
  # Add this if we ever add position in production
  #validates_formatting_of :image, using: :url
  #validates :image, format: { with: /\.(png|jpg|jpeg|)\z/,
  #                            message: 'must be .png, .jpg, or .jpeg' }

  auto_html_for :image do
    html_escape
    image
  end

  rails_admin do
    object_label_method :position
    navigation_label 'Daily Items'
    list do
      sort_by 'date desc, status_order_by, creator_id, created_at'
      include_fields :date, :position, :creator
      configure :date do
        strftime_format '%Y-%m-%d'
        column_width 75
      end
      field :status_with_color do
        label 'Status'
        sortable :status_order_by
        searchable :status
        column_width 90
      end
      configure :creator do
        column_width 85
      end
    end

    edit do
      include_fields :position, :description, :reviewed, :needs_work do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      configure :position do
        help 'Required. Length between 3 and 32. Must start with "The".'
      end
      configure :description do
        help ('Required. Length between 45 and 500. Should start with:<br>'\
              '"So you\'re doin\' a girl, preferably in the ace",<br>'\
              '"So you\'re doin\' a dude, definitely in the ace", or<br>'\
              '"So a girl\'s doin\' another girl, somehow in the ace".<br>'\
              'Description should be vivid and preferably not rapey (Finkle).'
             ).html_safe
      end
      include_fields :notes 
      include_fields :reviewed, :needs_work do
        visible do
          false
          # Change from the above to the below if we add position to the site
          #bindings[:object].reviewable?
        end
      end
    end

    show do
      include_fields :position, :description
      field :image_html
      field :creator
    end
  end

  def label
    self.position
  end

  private
    def sanitize
      Sanitize.clean!(self.position)
      Sanitize.clean!(self.image) if self.image.present?
      Sanitize.clean!(self.description)
    end
end
