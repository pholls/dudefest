class MoviesController < ApplicationController
  def index
    @movies = Movie.finalized
    @column = Column.movie
  end

  def show
    @movie = Movie.find(params[:id])
      
    redirect_to root_path unless @movie.review.public? 
  end
end
