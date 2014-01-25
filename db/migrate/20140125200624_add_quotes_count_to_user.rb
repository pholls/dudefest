class AddQuotesCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :quotes_count, :integer
  end
end
