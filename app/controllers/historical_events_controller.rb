class HistoricalEventsController < ApplicationController
  before_action :set_historical_event, only: [:show, :edit, :update, :destroy]
  before_action :new_historical_event, only: [:new, :create]
  before_action :historical_event_attributes, only: [:create, :update]

  def index
    @historical_events = HistoricalEvent.order(:date)
  end

  def show
  end

  def edit
  end

  def new
  end
  
  def create
    if @historical_event.save
      redirect_to @historical_event, 
                  notice: 'This event has been marked as a chapter in Dudefest History.'
    else
      render action: "new"
    end
  end

  def update
    if @historical_event.save
      redirect_to @historical_event, 
                  notice: 'This chapter in Dudefest History has been edited.'
    else
      render action: "edit" 
    end
  end

  def destroy
    @historical_event.destroy
    redirect_to historical_events_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_historical_event
      @historical_event = HistoricalEvent.find(params[:id])
    end

    def new_historical_event
      @historical_event = HistoricalEvent.new
    end

    def historical_event_attributes
      @historical_event.assign_attributes(historical_event_params)
    end

    # Never trust parameters from the scary internet, only allow the white list.
    def historical_event_params
      params.require(:historical_event).permit(:id, :event, :date, :link)
    end
end
