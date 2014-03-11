class ArticlesController < ApplicationController
  def index
    @topic = Topic.find(params[:topic]) if params[:topic].present?
    if @topic.present?
      @articles = Article.public_articles.select { |a| a.topic == @topic }
      @header = 'ON THE SUBJECT OF ' + @topic.topic
    else
      @articles = Article.public_articles
      @header = 'ALL ARTICLES WE\'VE WRITTEN'
    end
  end

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
