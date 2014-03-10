class Topic < ActiveRecord::Base
  has_paper_trail
  has_many :articles, inverse_of: :column

  validates :topic, presence: true, uniqueness: true, length: { in: 3..30 }

  rails_admin do
    navigation_label 'Articles'
    parent Article
    object_label_method :topic

    list do
      sort_by :topic
      include_fields :topic, :description
    end

    edit do
      include_fields :topic, :description
    end
  end

  def self.live
    self.where.not(articles_count: nil)
  end
end
