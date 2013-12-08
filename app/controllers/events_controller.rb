class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :new_event, only: [:new, :create]
  before_action :event_attributes, only: [:create, :update]

  def index
    @events = Event.order(:date)
  end

  def show
  end

  def edit
  end

  def new
  end
  
  def create
    if @event.save
      redirect_to @event, 
                  notice: 'This event has been marked as a chapter in Dudefest History.'
    else
      render action: "new"
    end
  end

  def update
    if @event.save
      redirect_to @event, 
                  notice: 'This chapter in Dudefest History has been edited.'
    else
      render action: "edit" 
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def new_event
      @event = Event.new
    end

    def event_attributes
      @event.assign_attributes(event_params)
    end

    # Never trust parameters from the scary internet, only allow the white list.
    def event_params
      params.require(:event).permit(:id, :event, :date, :link)
    end
end
