class RenameImageInArticles < ActiveRecord::Migration
  def change
    rename_column :articles, :image, :image_old
    add_column :articles, :image, :string
  end
end
