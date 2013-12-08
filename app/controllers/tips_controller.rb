class TipsController < ApplicationController
  before_action :set_tip, only: [:show, :edit, :update, :destroy]
  before_action :new_tip, only: [:new, :create]
  before_action :tip_attributes, only: [:create, :update]

  def index
    @tips = Tip.order(:date)
  end

  def show
  end

  def edit
  end

  def new
  end
  
  def create
    if @tip.save
      redirect_to @tip, notice: 'You got your tip in.'
    else
      render action: "new"
    end
  end

  def update
    if @tip.save
      redirect_to @tip, notice: 'You adjusted your tip.'
    else
      render action: "edit" 
    end
  end

  def destroy
    @tip.destroy
    redirect_to tips_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tip
      @tip = Tip.find(params[:id])
    end

    def new_tip
      @tip = Tip.new
    end

    def tip_attributes
      @tip.assign_attributes(tip_params)
    end

    # Never trust parameters from the scary internet, only allow the white list.
    def tip_params
      params.require(:tip).permit(:id, :tip, :reviewed)
    end
end
