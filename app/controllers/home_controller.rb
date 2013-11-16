class HomeController < ApplicationController
  def index
    @tip = Tip.of_the_day
    @historical_events = HistoricalEvent.this_day
  end
end
