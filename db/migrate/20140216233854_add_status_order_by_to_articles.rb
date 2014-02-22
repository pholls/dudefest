class AddStatusOrderByToArticles < ActiveRecord::Migration
  class Article < ActiveRecord::Base
  end

  def change
    add_column :articles, :status_order_by, :integer
    Article.reset_column_information
    reversible do |dir|
      dir.up { Article.all.each do |article|
        article.update_attribute :status_order_by, article.status.to_i
      end }
    end
  end
end
