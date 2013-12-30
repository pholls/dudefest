class Credit < ActiveRecord::Base
  belongs_to :movie, inverse_of: :credits
  belongs_to :name_variant, inverse_of: :credits

  validates :name_variant, uniqueness: { scope: :movie }
  # This cannot be used because of positioning in rails_admin
  # validates :position, presence: true, uniqueness: { scope: :movie }
  # Instead use this
  validates :position, presence: true

  default_scope { order(:position) }
end
