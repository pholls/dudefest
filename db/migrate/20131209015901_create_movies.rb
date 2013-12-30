class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.date :release_date
      t.integer :ratings_count
      t.decimal :total_rating
      t.integer :reviewed_ratings

      t.timestamps
    end
  end
end
