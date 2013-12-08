class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]
  before_action :new_position, only: [:new, :create]
  before_action :position_attributes, only: [:create, :update]

  def index
    @positions = Position.order(:date)
  end

  def show
  end

  def edit
  end

  def new
  end
  
  def create
    if @position.save
      redirect_to @position, notice: 'Your position has been created.'
    else
      render action: "new"
    end
  end

  def update
    if @position.save
      redirect_to @position, notice: 'Your position has been saved.'
    else
      render action: "edit" 
    end
  end

  def destroy
    @position.destroy
    redirect_to positions_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id])
    end

    def new_position
      @position = Position.new
    end

    def position_attributes
      @position.assign_attributes(position_params)
    end

    # Never trust parameters from the scary internet, only allow the white list.
    def position_params
      params.require(:position).permit(:id, :position, :image, :description)
    end
end
