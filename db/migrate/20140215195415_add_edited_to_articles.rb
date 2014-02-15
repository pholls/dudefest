class AddEditedToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :edited, :boolean
    Article.find_each do |article|
      article.edited = (article.status?('1 - Created') ? false : true)
    end
  end
end
