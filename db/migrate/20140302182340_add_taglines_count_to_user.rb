class AddTaglinesCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :taglines_count, :integer
  end
end
