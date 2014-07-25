class FeedbackMailer < ApplicationMailer
  def feedback_email(name, email, body)
    @name = name
    @email = email
    @body = body
    mail(from: named_email(name, email), 
         subject: "#{@name} has some feedback about the site")
  end
end
