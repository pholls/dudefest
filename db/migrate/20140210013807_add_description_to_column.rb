class AddDescriptionToColumn < ActiveRecord::Migration
  def change
    add_column :columns, :description, :text
  end
end
