class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true
  
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
    [self.name.camelcase, self.resource_type].compact.join(' of ')
  end
end
