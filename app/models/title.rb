class Title < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true, uniqueness: true

  rails_admin do
    object_label_method :title
    navigation_label 'Admin'
    parent User
    include_fields :title

    list do
      sort_by :title
      include_fields :user
    end
  end
end
