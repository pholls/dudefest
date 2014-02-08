class CreateArticleAuthors < ActiveRecord::Migration
  def change
    create_table :article_authors do |t|
      t.integer :author_id, index: true
      t.references :article, index: true
      t.integer :position

      t.timestamps
    end

    Article.find_each do |article|
      ArticleAuthor.create(article: article, author_id: article.author_id,
                           position: 1)
    end

    rename_column :articles, :author_id, :creator_id
  end
end
