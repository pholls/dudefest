class FeedbackController < ApplicationController
  def index
    @meta_description = 'Send feedback to the Dudefest.com team'
    @name ||= @email ||= @body ||= nil
  end

  def send_feedback
    @name = params[:name]
    @email = params[:email]
    @body = params[:body]

    flash[:error]  = ''
    flash[:error] += 'Need a name. '   if @name.blank?
    flash[:error] += 'Invalid email. ' if !valid_email?(@email)
    flash[:error] += 'Need feedback. ' if @body.blank?
    if flash[:error].blank?
      FeedbackMailer.feedback_email(@name, @email, @body).deliver_later
      redirect_to root_path, notice: 'Thanks for the feedback, dude'
    else
      render :index
    end
  end

  private
    def valid_email?(email)
      valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      email.present? && (email =~ valid_email_regex)
    end
end
