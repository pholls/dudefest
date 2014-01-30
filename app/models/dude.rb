class Dude < ActiveRecord::Base
  has_many :quotes, inverse_of: :dude

  before_validation :sanitize

  validates :name, presence: true, uniqueness: true
  
  rails_admin do
    object_label_method :name
    parent Quote
    include_fields :name

    list do
      sort_by :name
    end
  end

  private
    def sanitize
      Sanitize.clean!(self.name)
    end
end
