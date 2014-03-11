class UsersController < ApplicationController
  def index
    @users = User.where('role not in (?)', ['reader', 'writer'])
                 .order(articles_count: :desc)
  end

  def show
    @user = User.find(params[:id])
  end
end
