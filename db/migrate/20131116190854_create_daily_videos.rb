class CreateDailyVideos < ActiveRecord::Migration
  def change
    create_table :daily_videos do |t|
      t.string :title
      t.string :link
      t.date :date

      t.timestamps
    end
  end
end
