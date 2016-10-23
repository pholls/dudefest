class Position < ApplicationRecord
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

    list do
      include_fields :date, :position, :description, :creator, :status_with_color
      configure :position do
        column_width 200
      end
    end

    edit do
      include_fields :position, :description do
        read_only { is_read_only? }
      end
      configure :position do
        help 'Required. Length between 3 and 32. Must start with "The".'
      end
      configure :description do
        help { bindings[:object].description_html }
      end
      include_fields :reviewed, :needs_work, :published do
        visible false # remove override if position is eventually used
      end
      include_fields :notes, :current_user_id
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

  def description_help
    ('Required. Length between 45 and 500. Should start with:<br>'\
     '"So you\'re doin\' a girl, preferably in the ace",<br>'\
     '"So you\'re doin\' a dude, definitely in the ace", or<br>'\
     '"So a girl\'s doin\' another girl, somehow in the ace".<br>'\
     'Description should be vivid and preferably not rapey (Finkle).'
    ).html_safe
  end

  private
    def sanitize
      self.position = Sanitize.fragment(self.position)
      self.image = Sanitize.fragment(self.image) if self.image.present?
      self.description = Sanitize.fragment(self.description)
    end
end
