class AddStartDateToColumn < ActiveRecord::Migration
  def change
    add_column :columns, :start_date, :date
    Column.update_all(start_date: '2014-01-01')
    Column.where(column: 'Other').update_all(start_date: '2050-01-01')
  end
end
