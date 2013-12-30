class CreateNameVariants < ActiveRecord::Migration
  def change
    create_table :name_variants do |t|
      t.string :name_variant

      t.timestamps
    end
  end
end
