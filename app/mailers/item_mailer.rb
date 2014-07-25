class ItemMailer < ApplicationMailer

  def created_email(item)
    @item = item
    mail(to: collect_emails([@item.class.owner]), 
         subject: "There's a new #{item.class_name} to review!")
  end

  def needs_work_email(item)
    @item = item
    mail(to: collect_emails([@item.creator]),
         subject: "The #{item.class_name} you submitted needs a redo!")
  end

  def reviewed_email(item)
    @item = item
    mail(to: collect_emails([@item.creator]),
         subject: "The #{item.class_name} you submitted was reviewed!")
  end

  def published_email(item)
    @item = item
    mail(to: collect_emails([@item.creator]),
         subject: "The #{item.class_name} you submitted was published!")
  end

end
