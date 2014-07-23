class AddApprovalToArticles < ActiveRecord::Migration
  class Article < ActiveRecord::Base
  end

  class Role < ActiveRecord::Base
  end

  def change
    add_column :articles, :approved, :boolean, default: false, null: false
    add_column :articles, :approver_id, :integer

    Article.reset_column_information
    Role.reset_column_information

    reversible do |dir|
      dir.up { 
        Role.create(name: 'approver')
        Article.where('status_order_by > 1').find_each do |a|
          a.update_column :status_order_by, a.status_order_by + 1
          a.status[0] = a.status_order_by.to_s
          a.update_column :status, a.status
        end
      }
    end
  end
end
