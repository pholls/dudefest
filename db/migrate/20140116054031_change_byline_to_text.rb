class ChangeBylineToText < ActiveRecord::Migration
  def change
    change_column :articles, :byline, :text
    change_column :users, :byline, :text
  end
end
