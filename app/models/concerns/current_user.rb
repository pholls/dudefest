module CurrentUser
  extend ActiveSupport::Concern

  mattr_accessor :current_user_id

  included do
    rails_admin do
      configure :current_user_id, :hidden do
        formatted_value { current_user.id }
      end
    end
  end

  def current_user
    Current.user || current_user_id
  end
end
