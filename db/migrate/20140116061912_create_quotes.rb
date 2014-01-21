class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.text :quote
      t.references :dude, index: true
      t.text :context
      t.integer :year
      t.string :source
      t.date :date
      t.integer :creator_id
      t.integer :reviewer_id
      t.datetime :reviewed_at
      t.boolean :reviewed
      t.text :notes

      t.timestamps
    end
  end
end
