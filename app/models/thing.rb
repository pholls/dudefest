class Thing < ActiveRecord::Base
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
    navigation_label 'Daily Items'
    configure :image, :jcrop
    configure :thing_category do
      label 'Category'
      column_width 120
    end

    list do
      sort_by 'date desc, status_order_by, creator_id, created_at'
      include_fields :date, :thing_category, :thing, :creator
      configure :date do
        strftime_format '%Y-%m-%d'
        column_width 75
      end
      field :status_with_color do
        label 'Status'
        sortable :status_order_by
        column_width 90
      end
      configure :creator do
        column_width 85
      end
    end

    edit do
      include_fields :thing_category, :thing, :description, :image,
                     :reviewed, :needs_work, :published do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      configure :description do
        help ('Required. Between 150 and 500.<br>'\
              'That gives you a lot of room to wiggle. The generally agreed '\
              'upon form is to make this a definition.<br>Start your '\
              'description with the name of the thing because there '\
              'will be a picture separating it from the entry’s title.<br>'\
              'Make sure that if you’re using a first person pronoun '\
              'use "we" instead of "I" because Dudefest.com speaks '\
              'with one voice.<br>Make sure you have a punchline in mind '\
              'when you start your entry.').html_safe
      end
      field :image do
        jcrop_options aspectRatio: 400.0/300.0
        fit_image true
      end
      field :remote_image_url do
        label 'Or Image URL'
        read_only do
          bindings[:object].is_read_only?
        end
      end
      field :image_old do
        read_only true
      end
      configure :published do
        visible do
          bindings[:object].reviewed? 
        end
      end
      configure :needs_work do
        visible do
          bindings[:object].failable?
        end
      end
      configure :reviewed do
        visible do
          bindings[:object].reviewable? && !bindings[:object].reviewed?
        end
      end
      include_fields :notes
      field :weekly_output do
        read_only true
        help 'Make sure everyone knows how awesome your thing is.'
      end
    end

    show do
      include_fields :thing_category, :thing, :description, :creator
    end
  end
  
  public
    def category() self.thing_category.category; end

    def label
      self.thing
    end

    def display_image
      self.image.present? ? self.image.url.to_s : self.image_old
    end

  private
    def sanitize
      Sanitize.clean!(self.thing)
      Sanitize.clean!(self.description)
      Sanitize.clean!(self.image_old) if self.image_old.present?
    end
end
