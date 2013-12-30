class ThingCategory < ActiveRecord::Base
  validates :category, presence: true, length: { in: 3..32 }, uniqueness: true

  rails_admin do
    label 'Categories'
    object_label_method :category
    parent Thing
    list do
      sort_by :category
      include_fields :category
    end

    edit do
      include_fields :category
    end
  end
end
