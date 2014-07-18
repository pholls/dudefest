class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

  before_save :blank_resources
  
  scopify

  rails_admin do
    object_label_method :role_and_resource
    navigation_label 'Admin'
    parent 'User'

    list do
      sort_by :id
      field :id do; sort_reverse false; end
      field :role_and_resource do; label 'Role'; end
      include_fields :users 
    end
  end

  def role_and_resource
    [self.name.camelcase, self.resource_type].reject(&:blank?).join(' of ')
  end

  private
    def blank_resources
      self.resource_id = nil if self.resource_id.blank?
      self.resource_type = nil if self.resource_type.blank?
    end
end
