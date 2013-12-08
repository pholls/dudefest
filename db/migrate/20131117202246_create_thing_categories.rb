class CreateThingCategories < ActiveRecord::Migration
  def change
    create_table :thing_categories do |t|
      t.string :category
      t.integer :reviewer_id
      t.datetime :reviewed_at
      t.boolean :reviewed
      t.integer :creator_id

      t.timestamps
    end
  end
end
