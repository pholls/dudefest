class CreateThingCategories < ActiveRecord::Migration
  def change
    create_table :thing_categories do |t|
      t.string :category

      t.timestamps
    end
  end
end
