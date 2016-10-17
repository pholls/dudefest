class ArticleAuthor < ApplicationRecord
  belongs_to :article, inverse_of: :article_authors
  belongs_to :author, class_name: 'User', counter_cache: :articles_count,
                      inverse_of: :article_authors

  validates :author, uniqueness: { scope: :article }

  default_scope { order(:position) }
end
