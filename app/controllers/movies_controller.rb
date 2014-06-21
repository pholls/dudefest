class MoviesController < ApplicationController
  def index
    @movies = Movie.finalized
    @show_full_sidebar
    if params[:genre].present?
      @genre = Genre.find(params[:genre])
      @movies = @movies.select { |m| m.genres.include?(@genre) }
      @header = @genre.genre
    elsif params[:title].present?
      @movies = @movies.select { |m| m.title.include?(params[:title].upcase) }
      @header = params[:title]
    else
      @header = 'ALL'
      @show_full_sidebar = true
    end
    @column = Column.movie
  end

  def show
    @movie = Movie.find(params[:id])
    @commentable = @movie.review
    @comments = @commentable.root_comments.order(id: :desc)
    @comment = Comment.new
    @count = 10
    if user_signed_in? && current_user.has_role?(:writer)
      @fake_users = User.fake_or(current_user)
    end
      
    redirect_to root_path unless @commentable.public? 
  end
end
