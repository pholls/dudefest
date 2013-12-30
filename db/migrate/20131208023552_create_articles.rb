class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :author_id
      t.text :body
      t.integer :editor_id
      t.datetime :edited_at
      t.date :date
      t.datetime :responded_at
      t.datetime :finalized_at
      t.references :column
      t.string :status
      t.boolean :finalized
      t.integer :movie_id

      t.timestamps
    end
  end
end
