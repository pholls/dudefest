class Genre < ApplicationRecord
  has_paper_trail
  has_many :movie_genres, dependent: :destroy
  has_many :movies, through: :movie_genres

  before_validation :sanitize

  validates :genre, presence: :true, uniqueness: true
  # Uncomment this in a later release
  # validates :description, presence: :true, uniqueness: true

  default_scope { order(:genre) }

  rails_admin do
    object_label_method :genre
    navigation_label 'Movies'
    parent Movie

    list do
      sort_by :genre
      include_fields :genre, :description, :movies_count
    end

    edit do
      include_fields :genre, :description
    end
  end

  public
    def public_reviews
      self.movies.select { |movie| movie.review.public? }
                 .sort_by { |movie| movie.review.date }.reverse
    end

    def public_related(movie)
      self.public_reviews.select { |m| m != movie }
    end

  private
    def sanitize
      self.genre = Sanitize.fragment(self.genre)
      self.description = Sanitize.fragment(self.description) if self.description.present?
    end
end
