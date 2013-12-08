class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]
  before_action :new_video, only: [:new, :create]
  before_action :video_attributes, only: [:create, :update]

  def index
    @videos = Video.order(:date)
  end

  def show
  end

  def edit
  end

  def new
  end
  
  def create
    if @video.save
      redirect_to @video, notice: 'You got your video in.'
    else
      render action: "new"
    end
  end

  def update
    if @video.save
      redirect_to @video, notice: 'You adjusted your video.'
    else
      render action: "edit" 
    end
  end

  def destroy
    @video.destroy
    redirect_to videos_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    def new_video
      @video = Video.new
    end

    def video_attributes
      @video.assign_attributes(video_params)
    end

    # Never trust parameters from the scary internet, only allow the white list.
    def video_params
      params.require(:video).permit(:id, :title, :source)
    end
end
