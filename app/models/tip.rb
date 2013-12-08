class Tip < ActiveRecord::Base
  include ItemReview, DailyItem

  validates :tip, presence: true, length: { in: 10..200 }, uniqueness: true

  rails_admin do
    navigation_label 'Daily Items'
    list do
      sort_by :date, :created_at
      field :date do
        strftime_format '%Y-%m-%d'
      end
      field :tip do
        sortable false
      end
      field :creator
      field :reviewed
    end

    edit do
      field :tip
      field :reviewed do
        visible do
          bindings[:object].reviewable?
        end
      end
    end
  end
end
