class AddImageToColumn < ActiveRecord::Migration
  def change
    add_column :columns, :image, :string
  end
end
