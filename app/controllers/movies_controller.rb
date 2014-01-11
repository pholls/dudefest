class MoviesController < ApplicationController
  def index
    @movies = Movie.finalized
  end

  def show
    @movie = Movie.find(params[:id])
      
    redirect_to root_path unless @movie.review.public? 
  end
end
