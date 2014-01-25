class Dude < ActiveRecord::Base
  has_many :quotes, inverse_of: :dude
  
  rails_admin do
    object_label_method :name
    parent Quote
    include_fields :name
    sort_by :name
  end
end
