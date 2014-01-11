class MoviesController < ApplicationController
  def index
    @movies = Movie.finalized
  end

  def show
    @movie = Movie.find(params[:id])
  end
end
