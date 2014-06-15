class AddPublishedAtToRatings < ActiveRecord::Migration
  class Rating < ActiveRecord::Base
    belongs_to :movie
    has_one :review, through: :movie
  end

  class Movie < ActiveRecord::Base
    has_one :review, class_name: 'Article'
    belongs_to :creator, class_name: 'User', counter_cache: true
  end

  class Article < ActiveRecord::Base
    belongs_to :movie
  end

  def change
    add_column :ratings, :published_at, :datetime
    Rating.reset_column_information
    reversible do |dir|
      dir.up { Rating.find_each do |rating|
        if rating.reviewed? && rating.review.published?
          published_at = [rating.review.date.try(:midnight),
                          rating.reviewed_at].max_by { |d| d.to_i }
          rating.update_column :published_at, published_at
        end
      end }
    end
  end
end
