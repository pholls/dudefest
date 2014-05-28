class ArticlesController < ApplicationController
  def index
    @articles = Article.public_articles
    @header = 'ALL ARTICLES WE\'VE WRITTEN'
  end

  def show
    @commentable = @article = Article.find(params[:id])

    if !@article.public? 
      redirect_to root_path
    elsif @article.movie.present?
      redirect_to(@article.movie)
    end

    if user_signed_in? && current_user.has_role?(:writer)
      @fake_users = User.fake_or(current_user)
    end
    @column = @article.column
    @comments = @commentable.root_comments.order(created_at: :desc)
    @comment = Comment.new
  end
end
