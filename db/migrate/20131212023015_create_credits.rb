class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.references :movie, index: true
      t.references :name_variant, index: true
      t.integer :position

      t.timestamps
    end
  end
end
