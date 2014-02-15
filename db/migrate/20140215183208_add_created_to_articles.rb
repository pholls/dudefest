class AddCreatedToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :created, :boolean
    Article.find_each do |article|
      article.created = false
    end
  end
end
