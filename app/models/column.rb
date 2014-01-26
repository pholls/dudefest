class Column < ActiveRecord::Base
  has_many :articles, inverse_of: :column
  belongs_to :columnist, class_name: 'User'

  validates_associated :columnist, allow_blank: true
  validates :column, presence: true, uniqueness: true, length: { in: 4..50 }
  validates :short_name, presence: true, uniqueness: true, length: { in: 3..10 }

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
      include_fields :column, :short_name, :columnist, :articles_count
      configure :articles_count do
        label 'Articles'
        column_width 60
      end
    end

    edit do
      include_fields :column, :short_name, :columnist, :default_image
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
