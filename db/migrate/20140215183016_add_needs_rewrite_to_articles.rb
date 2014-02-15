class AddNeedsRewriteToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :needs_rewrite, :boolean
    Article.find_each do |article|
      article.needs_rewrite = false
    end
  end
end
