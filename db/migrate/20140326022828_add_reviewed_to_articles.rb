class AddReviewedToArticles < ActiveRecord::Migration
  class Article < ActiveRecord::Base
  end

  def change
    add_column :articles, :reviewed, :boolean, default: false, null: false
    add_column :articles, :reviewer_id, :integer
    Article.reset_column_information
    reversible do |dir|
      dir.up { 
        Article.where(published: true).update_all(reviewed: true, 
                                                  status: '6 - Published')
      }
    end
  end
end
