class ArticlesController < ApplicationController
  def show
    @article = Article.find(params[:id])

    if !@article.public? 
      redirect_to root_path
    elsif @article.movie.present?
      redirect_to(@article.movie)
    end
  end
end
