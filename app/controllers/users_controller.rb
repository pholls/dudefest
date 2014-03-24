class UsersController < ApplicationController
  def index
    @users = User.where(role: 'writer')
                 .select { |u| !u.public_articles.count.zero? }
  end

  def show
    @user = User.find(params[:id])
  end
end
