class InfoController < ApplicationController
  def index
    @video = DailyVideo.where(title: 'Ultimate Dudefest').first
  end
end
