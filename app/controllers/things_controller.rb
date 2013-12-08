class ThingsController < ApplicationController
  before_action :set_thing, only: [:show, :edit, :update, :destroy]
  before_action :new_thing, only: [:new, :create]
  before_action :thing_attributes, only: [:create, :update]

  def index
    @things = Thing.all
  end

  def show
  end

  def edit
  end

  def new
  end
  
  def create
    if @thing.save
      redirect_to @thing, notice: 'This Thing Category was created.' 
    else
      render action: "new"
    end
  end

  def update
    if @thing.save
      redirect_to @thing, notice: 'This Thing Category was edited.' 
    else
      render action: "edit" 
    end
  end

  def destroy
    @thing.destroy
    redirect_to things_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thing
      @thing = Thing.find(params[:id])
    end

    def new_thing
      @thing = Thing.new
    end

    def thing_attributes
      @thing.assign_attributes(thing_params)
    end

    # Never trust parameters from the scary internet, only allow the white list.
    def thing_params
      params.require(:thing).permit(:id, :thing, :image, :description, 
                                    :thing_category_id)
    end
end
