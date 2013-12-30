class NameVariant < ActiveRecord::Base
  has_many :credits, inverse_of: :name_variant, dependent: :destroy
  has_many :movies, through: :credits

  validates :name_variant, presence: true, uniqueness: true

  rails_admin do
    label 'Dude'
    object_label_method :name_variant
    navigation_label 'Movies'
    parent Movie
    configure :name_variant do
      label 'Dude'
    end

    list do
      sort_by :name_variant
      include_fields :name_variant
    end

    edit do
      include_fields :name_variant
    end

    show do
      include_fields :name_variant
    end
  end
end
