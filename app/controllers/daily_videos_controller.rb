class DailyVideosController < ApplicationController
  before_action :new_daily_video, only: [:new, :create]
  before_filter :authenticate_user!

  def new
  end

  def create
    @daily_video.assign_attributes(daily_video_params)
    if @daily_video.save
      redirect_to root_path, alert: 'Thanks for putting your daily_video in!'
    else
      render :new
    end
  end

  private
    def new_daily_video
      @daily_video = DailyVideo.new 
      @meta_description = 'We can\'t watch all the videos on the internet. '\
                          'Help us out.'
      @sample_videos = DailyVideo.random_live(1)
    end

    def daily_video_params
      params.require(:daily_video).permit(:title, :source)
    end
end
