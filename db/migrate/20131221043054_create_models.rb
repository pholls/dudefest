class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :model
      t.references :owner, index: true
      t.date :start_date

      t.timestamps
    end
  end
end
