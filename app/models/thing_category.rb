class ThingCategory < ActiveRecord::Base
  validates :category, presence: true, length: { in: 3..32 }, uniqueness: true

  rails_admin do
    object_label_method :category
    list do
      sort_by :category
      field :id
      field :category
    end

    edit do
      field :category
    end
  end
end
