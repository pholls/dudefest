class ArticleMailer < ActionMailer::Base
  default from: 'dudes@dudefest.com'

  def created_email(article)
    @article = article
    mail(to: @article.editor.email, 
         subject: 'You got an article to edit, brah!')
  end

  def edited_email(article)
    @article = article
    mail(to: @article.creator.email,
         subject: 'You got some edits to respond to, brah!')
  end

  def responded_email(article)
    @article = article
    mail(to: @article.editor.email,
         subject: 'You got some responses to your edits, brah!')
  end

  def rejected_email(article)
    @article = article
    emails = [@article.editor, @article.creator].collect(&:email).join(',')
    mail(to: emails, subject: 'An article got rejected, brah!')
  end

  def rewrite_email(article)
    @article = article
    mail(to: @article.creator.email,
         subject: 'You got an article to rewrite, brah!')
  end
end
