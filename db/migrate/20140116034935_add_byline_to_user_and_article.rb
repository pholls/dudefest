class AddBylineToUserAndArticle < ActiveRecord::Migration
  def change
    add_column :users, :byline, :string
    add_column :articles, :byline, :string
  end
end
