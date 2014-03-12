class Column < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  process_in_background :image

  has_paper_trail
  has_many :articles, inverse_of: :column
  belongs_to :columnist, class_name: 'User'

  before_validation :sanitize

  validates_associated :columnist, allow_blank: true
  validates :column, presence: true, uniqueness: true, length: { in: 4..50 }
  validates :short_name, presence: true, uniqueness: true, length: { in: 3..10 }
  validates :image, presence: true, if: :active?
  validates :start_date, presence: true, if: :active?
  validates :description, presence: true, uniqueness: true, if: :active?
  validates :publish_days, presence: true, if: :active?, uniqueness: true, 
                           length: { in: 1..7 }, 
                           format: { with: /\A[1-7]+\z/,
                                     message: 'must be days of the week' }

  rails_admin do
    object_label_method :short_name
    navigation_label 'Articles'
    parent Article
    configure :image, :jcrop
    configure :short_name do
      label 'Short'
      column_width 50
    end

    list do
      sort_by :column
      include_fields :column, :short_name, :publish_days, :articles_count, 
                     :active
      configure :publish_days do
        label 'Days'
        column_width 45
      end
      configure :articles_count do
        label 'Articles'
        column_width 60
      end
      configure :active do
        column_width 50
      end
    end

    edit do
      include_fields :column, :short_name, :columnist, :publish_days,
                     :start_date, :active, :description
      field :image do
        jcrop_options aspectRatio: 400.0/300.0
        fit_image true
      end
      field :remote_image_url do
        label 'Or Image URL'
      end
    end

    show do
      include_fields :column, :short_name, :columnist, :description
    end
  end

  public
    def to_param
      self.short_name.downcase
    end

    def public_articles
      self.articles.order(date: :desc).select { |article| article.public? }
    end

    def self.live
      self.where.not(short_name: 'Cinema').where('start_date <= ?', Date.today)
          .order(:column)
    end

    def self.movie
      self.where(short_name: 'Cinema').first
    end

    def self.guyde
      self.where(short_name: 'Guyde').first
    end

  private
    def sanitize
      Sanitize.clean!(self.column)
      Sanitize.clean!(self.short_name)
    end
end
