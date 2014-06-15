class TipsController < ApplicationController
  before_action :new_tip, only: [:new, :create]
  before_filter :authenticate_user!

  def new
  end

  def create
    @tip.assign_attributes(tips_params)
    if @tip.save
      redirect_to session[:previous_url], 
                  alert: 'Thanks for putting your tip in!'
    else
      render :new
    end
  end

  private
    def new_tip
      @tip = Tip.new 
      @meta_description = 'At Dudefest.com we\'re tired of our tips, so we\'d '\
                          'love if you gave us yours.'
      @sample_tips = Tip.random_live(3)
    end

    def tips_params
      params.require(:tip).permit(:tip)
    end
end
