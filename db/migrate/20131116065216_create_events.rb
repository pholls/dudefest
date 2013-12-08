class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :event
      t.string :link
      t.date :date
      t.integer :reviewer_id
      t.datetime :reviewed_at
      t.boolean :reviewed
      t.integer :creator_id

      t.timestamps
    end
  end
end
