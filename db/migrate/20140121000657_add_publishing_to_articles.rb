class AddPublishingToArticles < ActiveRecord::Migration
  class Article < ActiveRecord::Base
  end

  def change
    add_column :articles, :published, :boolean
    add_column :articles, :published_at, :datetime
    Article.reset_column_information
    reversible do |dir|
      dir.up { Article.all.each do |a|
        a.update_attribute :published, a.finalized
        a.update_attribute :published_at, a.finalized_at
        a.update_attribute :status, '5 - Published' if a.finalized?
      end }
    end
  end
end
