class UsersController < ApplicationController
  def index
    @users = User.with_role(:writer)
                 .select { |u| !u.public_articles.count.zero? } - @writers
  end

  def show
    if is_number? params[:id]
      redirect_to user_path User.find(params[:id])
    else
      @user = User.find_by username: params[:id]
    end
    @recent_ratings = Rating.recent(10, @user)
    @recent_comments = Comment.recent(10, @user)
  end

  private
    def is_number?(string)
      true if Float(string) rescue false
    end
end
