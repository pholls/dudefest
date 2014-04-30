class CommentsController < ApplicationController
  before_filter :load_commentable

  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    if params[:comment][:user_id].nil? 
      @user = current_user
    else 
      @user = User.find(params[:comment][:user_id])
    end
    @comment = Comment.build_from(@commentable, @user, 
                                  params[:comment][:body])
    if params[:comment][:parent_id].present?
      @comment.parent_id = params[:comment][:parent_id].to_i
    end
    @comment.creator = current_user
    if @comment.save 
      redirect_to @commentable, notice: 'Comment created.'
    else
      render :new
    end
  end

  private
    def load_commentable
      resource, id = request.path.split('/')[1, 2]
      @commentable = resource.singularize.classify.constantize.find(id)
    end
end
