class Thing < ApplicationRecord
  include EasternTime, ModelConfig, ItemReview, DailyItem, WeeklyOutput
  mount_uploader :image, ImageUploader
  process_in_background :image

  before_validation :sanitize

  has_paper_trail
  belongs_to :thing_category, inverse_of: :things

  validates :thing, presence: true, length: { in: 3..26 }, uniqueness: true
  validates :description, presence: true, length: { in: 150..500}, 
                          uniqueness: true
  validates :thing_category, presence: true
  validates :image, presence: true

  auto_html_for :image_old do
    html_escape
    image
  end

  rails_admin do
    object_label_method :thing
    configure :image, :jcrop

    configure :thing_category do
      label 'Category'
      column_width 110
    end

    list do
      include_fields :date, :thing_category, :thing, :description, :creator, :status_with_color
      configure :thing do
        column_width 190
      end
    end

    edit do
      include_fields :thing_category, :thing, :description, :image do
        read_only { is_read_only? }
      end

      configure :description do
        help { bindings[:object].description_help }
      end
      field :image do
        jcrop_options aspectRatio: 400.0/300.0
        fit_image true
      end
      field :remote_image_url do
        label 'Or Image URL'
        read_only { is_read_only? }
      end
      field :image_old do
        read_only true
      end
      include_fields :reviewed, :needs_work, :published, :notes, :weekly_output
      field :current_user_id
    end

    show do
      include_fields :thing_category, :thing, :description, :creator
    end
  end
  
  public
    def category; self.thing_category.category; end

    def label
      self.thing
    end

    def display_image
      self.image ? self.image.url.to_s : self.image_old
    end

    def description_help
      ('Required. Between 150 and 500.<br>'\
       'That gives you a lot of room to wiggle. The generally agreed '\
       'upon form is to make this a definition.<br>Start your '\
       'description with the name of the thing because there '\
       'will be a picture separating it from the entry’s title.<br>'\
       'Make sure that if you’re using a first person pronoun '\
       'use "we" instead of "I" because Dudefest.com speaks '\
       'with one voice.<br>Make sure you have a punchline in mind '\
       'when you start your entry.').html_safe
    end

    def weekly_output_help
      'Make sure everyone knows how awesome your thing is.'
    end

  private
    def sanitize
      self.thing = Sanitize.fragment(self.thing)
      self.description = Sanitize.fragment(self.description)
      self.image_old = Sanitize.fragment(self.image_old) if self.image_old.present?
    end
end
