class ArticlesController < ApplicationController
  def show
    @commentable = @article = Article.find(params[:id])

    if !@article.public? 
      redirect_to root_path
    elsif @article.movie.present?
      redirect_to(@article.movie)
    end

    @comments = @commentable.root_comments
    @comment = Comment.new
  end
end
