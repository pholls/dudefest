class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.string :column
      t.string :short_name
      t.integer :columnist_id
      t.integer :articles_count

      t.timestamps
    end
  end
end
