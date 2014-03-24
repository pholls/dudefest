class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_current_user
  before_filter :set_daily_dose
  before_filter :set_nav
  after_filter :store_location
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
      devise_parameter_sanitizer.for(:account_update) { |u|
        u.permit(:username, :email, :name, :password, :password_confirmation,
                 :current_password, :bio)
      }
    end

    def store_location
      unless (request.fullpath == '/users/sign_in' || 
              request.fullpath == '/users/sign_up' ||
              request.fullpath == '/users/sign_out' ||
              request.fullpath == '/users/password' || request.xhr?)
        session[:previous_url] = request.fullpath
      end
    end

    def after_sign_in_path_for(resource)
      session[:previous_url] || root_path
    end

    def after_update_path_for(resource)
      session[:previous_url] || root_path
    end

    def after_sign_out_path_for(resource)
      session[:previous_url] || root_path
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
      @genres = Genre.unscoped.where.not(genre: 'Superhero')
                     .order(movies_count: :desc).limit(8)
      @writers = User.order(articles_count: :desc).limit(8)
                     .sort_by { |u| u.public_articles.count }.reverse
      @tagline = Tagline.where(reviewed: true).order('RANDOM()').first
    end
end
