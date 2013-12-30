class MovieGenre < ActiveRecord::Base
  belongs_to :movie
  belongs_to :genre, counter_cache: :movies_count
  
  validates :genre, uniqueness: { scope: :movie }
end
