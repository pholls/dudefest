class AddCreatorToMovies < ActiveRecord::Migration
  class Movie < ActiveRecord::Base
    has_one :review, class_name: 'Article'
    belongs_to :creator, class_name: 'User', counter_cache: true
  end

  class Article < ActiveRecord::Base
    belongs_to :movie
  end

  class User < ActiveRecord::Base
    has_many :movies, foreign_key: 'creator_id'
  end

  def change
    add_column :movies, :creator_id, :integer

    Movie.reset_column_information
    reversible do |dir|
      dir.up { 
        Movie.find_each do |movie|
          movie.update_attribute :creator_id, movie.review.creator_id
        end
        User.find_each do |user|
          User.reset_counters(user.id, :movies)
        end
      }
    end
  end
end
