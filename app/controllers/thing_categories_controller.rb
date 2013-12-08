class ThingCategoriesController < ApplicationController
  before_action :set_thing_category, only: [:show, :edit, :update, :destroy]
  before_action :new_thing_category, only: [:new, :create]
  before_action :thing_category_attributes, only: [:create, :update]

  def index
    @thing_categories = ThingCategory.order(:category)
  end

  def show
  end

  def edit
  end

  def new
  end
  
  def create
    if @thing_category.save
      redirect_to @thing_category, notice: 'This Thing Category was created.' 
    else
      render action: "new"
    end
  end

  def update
    if @thing_category.save
      redirect_to @thing_category, notice: 'This Thing Category was edited.' 
    else
      render action: "edit" 
    end
  end

  def destroy
    @thing_category.destroy
    redirect_to thing_categories_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thing_category
      @thing_category = ThingCategory.find(params[:id])
    end

    def new_thing_category
      @thing_category = ThingCategory.new
    end

    def thing_category_attributes
      @thing_category.assign_attributes(thing_category_params)
    end

    # Never trust parameters from the scary internet, only allow the white list.
    def thing_category_params
      params.require(:thing_category).permit(:id, :category)
    end
end
