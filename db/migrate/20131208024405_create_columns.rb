class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.string :column
      t.string :short_name
      t.integer :columnist_id
      t.integer :articles_count
      t.string :default_image
      t.integer :days_between_posts

      t.timestamps
    end
  end
end
