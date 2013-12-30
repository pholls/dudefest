class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :creator_id
      t.decimal :rating
      t.text :body
      t.integer :reviewer_id
      t.datetime :reviewed_at
      t.boolean :reviewed
      t.text :notes
      t.references :movie

      t.timestamps
    end
  end
end
