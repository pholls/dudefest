class AddPublishDaysToColumn < ActiveRecord::Migration
  def change
    add_column :columns, :publish_days, :string
  end
end
