class Role < ApplicationRecord
  before_save :blank_resources

  scopify

  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

  validates :name, presence: true

  rails_admin do
    object_label_method :role_and_resource
    navigation_label 'Admin'
    parent 'User'

    list do
      sort_by :id
      field :id do
        sort_reverse false
        column_width 35
      end
      field :role_and_resource do
        label 'Role'
        column_width 140
      end
      include_fields :users 
    end

    edit do
      include_fields :name, :resource, :users
    end
  end

  def role_and_resource
    if self.name.present?
      [self.name.camelcase, self.resource_type].reject(&:blank?).join(' of ')
    else
      'New Role'
    end
  end

  private
    def blank_resources
      self.resource_id = nil if self.resource_id.blank?
      self.resource_type = nil if self.resource_type.blank?
    end
end
