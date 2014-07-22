class ApplicationMailer < ActionMailer::Base
  default from: '"John Dudefest" <dudes@dudefest.com>'
  require 'mail'

  private
    def collect_emails(users = [])
      (User.with_role(:admin) | users).map do |user|
        address = Mail::Address.new user.email
        address.display_name = user.name
        address.format
      end.join(',')
    end
end
