class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.string :thing
      t.string :image
      t.text :description
      t.date :date
      t.references :thing_category, index: true
      t.integer :reviewer_id
      t.datetime :reviewed_at
      t.boolean :reviewed
      t.integer :creator_id
      t.text :notes

      t.timestamps
    end
  end
end
