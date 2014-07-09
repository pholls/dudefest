class ItemMailer < ActionMailer::Base
  default from: "dudes@dudefest.com"

  def created_email(item)
    @item = item
    mail(to: @item.class.owner.email, 
         subject: "There's a new #{item.class_name} to review!")
  end

  def needs_work_email(item)
    @item = item
    mail(to: @item.creator.email,
         subject: "The #{item.class_name} you submitted needs a redo!")
  end
end
