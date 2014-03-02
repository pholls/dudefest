class AddTopicToArticles < ActiveRecord::Migration
  def change
    add_reference :articles, :topic, index: true
  end
end
