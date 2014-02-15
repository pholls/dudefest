class Model < ActiveRecord::Base
  has_paper_trail
  belongs_to :owner, class_name: 'User'

  validates :model, presence: true, uniqueness: true
  validates_associated :owner
  validates :start_date, presence: true

  rails_admin do
    object_label_method :model
    navigation_label 'Admin'

    list do
      sort_by :model
      include_fields :model, :owner, :start_date
    end

    edit do
      include_fields :model, :owner, :start_date
    end
  end
end
