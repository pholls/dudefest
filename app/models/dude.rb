class Dude < ApplicationRecord
  include CurrentUser

  has_paper_trail
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

    edit do
      configure :name do
        help 'Required. Should be the actual name of the dude. '\
             'Keep it consistent bros.'
      end
    end
  end

  private
    def sanitize
      self.name = Sanitize.fragment(self.name)
    end
end
