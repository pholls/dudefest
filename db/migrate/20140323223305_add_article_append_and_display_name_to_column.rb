class AddArticleAppendAndDisplayNameToColumn < ActiveRecord::Migration
  def change
    add_column :columns, :article_append, :string
    add_column :columns, :display_name, :string
  end
end
