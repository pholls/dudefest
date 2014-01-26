class ThingCategory < ActiveRecord::Base
  has_many :things, inverse_of: :thing_category
  validates :category, presence: true, length: { in: 3..15 }, uniqueness: true

  rails_admin do
    label 'Categories'
    object_label_method :category
    parent Thing
    include_fields :category

    list do
      sort_by :category
    end
  end
end
