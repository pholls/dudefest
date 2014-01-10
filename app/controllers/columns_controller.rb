class ColumnsController < ApplicationController
  def show
    @column = Column.where('lower(short_name) = ?', params[:id]).first

    if @column == Column.movie
      redirect_to movies_path
    end
  end
end
