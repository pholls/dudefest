class ApplicationMailer < ActionMailer::Base
  default from: '"John Dudefest" <dudes@dudefest.com>'
  default to: '"Brain Trust" <braintrust@dudefest.com>'
  require 'mail'

  private
    def named_email(name, email)
      address = Mail::Address.new email
      address.display_name = name
      address.format
    end

    def collect_emails(users = [])
      (User.with_role(:admin) | users).map do |user|
        named_email(user.name, user.email)
      end.join(',')
    end
end
