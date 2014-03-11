class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_current_user
  before_filter :set_daily_dose
  before_filter :set_nav
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, :alert => exception.message
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u|
        u.permit(:username, :email, :password, :password_confirmation) 
      }
      devise_parameter_sanitizer.for(:sign_in) { |u| 
        u.permit(:username, :password, :remember_me) 
      }
    end

  private
    def set_current_user
      User.current = current_user
    end

    def set_daily_dose
      @daily_video = DailyVideo.of_the_day
      @thing = Thing.of_the_day
      @tip = Tip.of_the_day
      @quote = Quote.of_the_day
      @position = Position.of_the_day
      @events = Event.this_day
    end

    def set_nav
      @columns = Column.order(:column).live
      @topics = Topic.order(:topic).live.limit(5)
      @genres = Genre.unscoped.order(movies_count: :desc).limit(6)
      @writers = User.order(articles_count: :desc).limit(8)
      @tagline = Tagline.where(reviewed: true).order('RANDOM()').first
    end
end
