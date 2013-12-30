class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.text :tip
      t.date :date
      t.integer :reviewer_id
      t.datetime :reviewed_at
      t.boolean :reviewed
      t.integer :creator_id
      t.text :notes

      t.timestamps
    end
  end
end
