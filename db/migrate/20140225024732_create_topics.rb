class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :topic
      t.text :description
      t.integer :articles_count

      t.timestamps
    end
  end
end
