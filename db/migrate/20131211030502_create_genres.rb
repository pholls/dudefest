class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :genre
      t.text :description
      t.integer :movies_count

      t.timestamps
    end
  end
end
