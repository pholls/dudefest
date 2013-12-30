class CreateDailyVideos < ActiveRecord::Migration
  def change
    create_table :daily_videos do |t|
      t.string :title
      t.string :source
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
