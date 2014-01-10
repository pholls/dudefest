class HomeController < ApplicationController
  def index
    @articles = Article.public
  end
end
