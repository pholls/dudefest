class ColumnsController < ApplicationController
  def index
    # columns are set in application controller
    @articles = Article.public.first(10)
    @meta_description = 'The Dudefest.com dudes write articles that follow '\
                        'one of a few specific formats. These are those '\
                        'formats'
  end
  
  def show
    @column = Column.where('lower(short_name) = ?', params[:id]).first

    if @column == Column.movie
      redirect_to movies_path
    end
  end
end
