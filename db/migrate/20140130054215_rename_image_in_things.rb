class RenameImageInThings < ActiveRecord::Migration
  def change
    rename_column :things, :image, :image_old
    add_column :things, :image, :string
  end
end
