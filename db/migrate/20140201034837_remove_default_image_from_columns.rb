class RemoveDefaultImageFromColumns < ActiveRecord::Migration
  def change
    remove_column :columns, :default_image, :string
  end
end
