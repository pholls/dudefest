class MoviesController < ApplicationController
  def index
    @movies = Movie.finalized
    @column = Column.movie
  end

  def show
    @movie = Movie.find(params[:id])
    @commentable = @movie.review
    @comments = @commentable.root_comments
    @comment = Comment.new
      
    redirect_to root_path unless @commentable.public? 
  end
end
