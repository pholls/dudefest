class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.string :title
      t.references :user, index: true

      t.timestamps
    end
  end
end
