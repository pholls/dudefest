class Topic < ApplicationRecord
  has_paper_trail
  has_many :articles, inverse_of: :topic

  validates :topic, presence: true, uniqueness: true, length: { in: 3..30 }

  rails_admin do
    navigation_label 'Articles'
    parent Article
    object_label_method :topic

    list do
      sort_by :topic
      include_fields :topic, :description, :articles_count

      configure :topic do
        column_width 150
      end

      configure :articles_count do
        label 'Articles'
        column_width 70
      end
    end

    edit do
      include_fields :topic, :description
    end
  end

  def to_param; self.topic.gsub(' ', '+'); end

  def public_articles
    self.articles.order(date: :desc).select { |article| article.public? }
  end

  def public_related(column)
    self.public_articles.select { |article| article.column != column }
  end

  def self.live
    self.where.not(articles_count: nil)
  end
end
