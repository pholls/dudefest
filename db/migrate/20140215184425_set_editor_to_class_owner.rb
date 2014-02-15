class SetEditorToClassOwner < ActiveRecord::Migration
  def change
    Article.find_each do |article|
      article.editor = Article.owner
    end
  end
end
