class Column < ActiveRecord::Base
  has_many :articles, inverse_of: :column
  belongs_to :columnist, class_name: 'User'

  validates_associated :columnist, allow_blank: true
  validates :column, presence: true, uniqueness: true, length: { in: 4..50 }
  validates :short_name, presence: true, uniqueness: true, length: { in: 3..10 }
  validates :start_date, presence: true
  validates :publish_days, presence: true, uniqueness: true, 
                           length: { in: 1..7 }, 
                           format: { with: /\A[1-7]+\z/,
                                     message: 'must be days of the week' }
  validates :default_image, presence: true, uniqueness: true

  auto_html_for :default_image do
    html_escape
    image
  end

  rails_admin do
    object_label_method :short_name
    navigation_label 'Articles'
    parent Article
    configure :short_name do
      label 'Short Name'
      column_width 90
    end

    list do
      sort_by :column
      include_fields :column, :short_name, :columnist, :publish_days,
                     :articles_count
      configure :publish_days do
        label 'Days'
        column_width 60
      end
      configure :articles_count do
        label 'Articles'
        column_width 60
      end
      configure :columnist do
        column_width 80
      end
    end

    edit do
      include_fields :column, :short_name, :columnist, :publish_days,
                     :start_date, :default_image
    end

    show do
      include_fields :column, :short_name, :columnist
      field :default_image_html
    end
  end

  public
    def to_param
      self.short_name.downcase
    end

    def public_articles
      self.articles.order(date: :desc).select { |article| article.public? }
    end

    def self.movie
      self.where(short_name: 'Cinema').first
    end

    def self.guyde
      self.where(short_name: 'Guyde').first
    end
end
