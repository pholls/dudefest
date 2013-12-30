class Genre < ActiveRecord::Base
  has_many :movie_genres, dependent: :destroy
  has_many :movies, through: :movie_genres

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
end
