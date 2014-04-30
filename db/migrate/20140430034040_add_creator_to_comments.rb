class AddCreatorToComments < ActiveRecord::Migration
  class Comment < ActiveRecord::Base
  end

  def change
    add_column :comments, :creator_id, :integer
    Comment.reset_column_information
    reversible do |dir|
      dir.up { Comment.find_each do |comment|
        comment.update_column :creator_id, comment.user_id
      end }
    end
  end
end
