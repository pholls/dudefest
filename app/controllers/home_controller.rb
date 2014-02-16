class HomeController < ApplicationController
  def index
    @all_articles = Article.public
    @top_two = @all_articles.shift(2)
    @articles = Kaminari.paginate_array(@all_articles).page(params[:page])
  end
end
