class Column < ActiveRecord::Base
  has_many :articles, counter_cache: true
  belongs_to :columnist, class_name: 'User'

  validates_associated :columnist, allow_blank: true
  validates :column, presence: true, uniqueness: true, length: { in: 4..32 }
  validates :short_name, presence: true, uniqueness: true, length: { in: 3..10 }

  rails_admin do
    object_label_method :column
    list do
      sort_by :column
      field :column
      field :short_name
      field :columnist
      field :articles_count
    end

    edit do
      field :column
      field :short_name
      field :columnist
    end
  end
end
