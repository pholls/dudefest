class Dude < ActiveRecord::Base
  has_many :quotes, inverse_of: :dude

  validates :name, presence: true, uniqueness: true
  
  rails_admin do
    object_label_method :name
    parent Quote
    include_fields :name

    list do
      sort_by :name
    end
  end
end
