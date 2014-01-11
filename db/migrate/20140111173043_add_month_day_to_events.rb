class AddMonthDayToEvents < ActiveRecord::Migration
  class Event < ActiveRecord::Base
  end

  def change
    add_column :events, :month_day, :integer

    Event.reset_column_information
    reversible do |dir|
      dir.up { Event.all.each do |e|
        e.update_attribute :month_day, e.date.month * 100 + e.date.day
      end }
    end
  end
end
