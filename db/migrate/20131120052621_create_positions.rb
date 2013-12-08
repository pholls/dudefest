class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :position
      t.string :image
      t.text :description
      t.date :date
      t.integer :reviewer_id
      t.datetime :reviewed_at
      t.boolean :reviewed
      t.integer :creator_id

      t.timestamps
    end
  end
end
