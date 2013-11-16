class CreateHistoricalEvents < ActiveRecord::Migration
  def change
    create_table :historical_events do |t|
      t.text :event
      t.date :date
      t.string :link

      t.timestamps
    end
  end
end
