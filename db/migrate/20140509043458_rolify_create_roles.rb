class RolifyCreateRoles < ActiveRecord::Migration
  class Role < ActiveRecord::Base
  end

  def change
    create_table(:roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:users_roles) do |t|
      t.references :user
      t.references :role
    end

    add_index(:roles, :name)
    add_index(:roles, [ :name, :resource_type, :resource_id ])
    add_index(:users_roles, [ :user_id, :role_id ])

    Role.reset_column_information
    reversible do |dir|
      dir.up { 
        Role.create(name: 'admin')
        Role.create(name: 'editor')
        Role.create(name: 'reviewer')
        Role.create(name: 'dude')
        Role.create(name: 'writer')
        Role.create(name: 'fake')

        User.find_each do |user|
          user.add_role user.role unless user.role == 'reader'
          if ['admin', 'editor', 'reviewer', 'writer'].include?(user.role)
            user.add_role :writer
            user.add_role :dude if user.role != 'writer'
          end
          Model.where(owner: user).find_each do |model|
            user.add_role :owner, model.model.constantize
          end
        end
      }
    end
  end
end
