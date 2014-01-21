class CreateDudes < ActiveRecord::Migration
  def change
    create_table :dudes do |t|
      t.string :name
      t.integer :quotes_count

      t.timestamps
    end
  end
end
