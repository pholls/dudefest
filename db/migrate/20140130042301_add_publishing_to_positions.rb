class AddPublishingToPositions < ActiveRecord::Migration
  class Position < ActiveRecord::Base
  end

  def change
    add_column :positions, :published, :boolean
    add_column :positions, :published_at, :datetime
    Position.reset_column_information
    reversible do |dir|
      Position.update_all(published: false)
    end
  end
end
