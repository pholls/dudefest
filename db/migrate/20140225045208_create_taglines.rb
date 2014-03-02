class CreateTaglines < ActiveRecord::Migration
  def change
    create_table :taglines do |t|
      t.string :tagline
      t.integer :creator_id
      t.boolean :reviewed
      t.text :notes
      t.integer :reviewer_id
      t.datetime :reviewed_at

      t.timestamps
    end
  end
end
