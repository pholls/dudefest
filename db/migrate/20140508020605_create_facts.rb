class CreateFacts < ActiveRecord::Migration
  def change
    create_table :facts do |t|
      t.text :fact
      t.integer :creator_id
      t.string :nickname
      t.integer :reviewer_id
      t.boolean :reviewed
      t.datetime :reviewed_at
      t.text :notes

      t.timestamps
    end
  end
end
