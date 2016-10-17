class NameVariant < ApplicationRecord
  has_paper_trail
  has_many :credits, inverse_of: :name_variant, dependent: :destroy
  has_many :movies, through: :credits

  before_validation :sanitize

  validates :name_variant, presence: true, uniqueness: true

  rails_admin do
    label 'Dude'
    object_label_method :name_variant
    navigation_label 'Movies'
    parent Movie
    include_fields :name_variant do
      label 'Dude'
    end

    list do
      sort_by :name_variant
    end
  end

  private
    def sanitize
      self.name_variant = Sanitize.fragment(self.name_variant)
    end
end
