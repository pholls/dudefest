class UsersController < ApplicationController
  def index
    @users = User.where(role: 'writer')
                 .select { |u| !u.public_articles.count.zero? }
  end

  def show
    if is_number? params[:id]
      redirect_to user_path User.find(params[:id])
    else
      @user = User.find_by username: params[:id]
    end
  end

  private
    def is_number?(string)
      true if Float(string) rescue false
    end
end
