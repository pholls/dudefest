class AddPublishingToDailyItems < ActiveRecord::Migration
  class DailyVideo < ActiveRecord::Base
  end

  class Tip < ActiveRecord::Base
  end

  class Thing < ActiveRecord::Base
  end

  class Quote < ActiveRecord::Base
  end

  def change
    tables = [:daily_videos, :tips, :things, :quotes]
    models = [DailyVideo, Tip, Thing, Quote]
    tables.each do |t|
      add_column t, :published, :boolean
      add_column t, :published_at, :datetime
    end

    models.each do |m|
      m.reset_column_information
    end

    reversible do |dir|
      dir.up { models.each do |m| 
        m.all.each do |item|
          item.update_attribute :published, item.reviewed
          item.update_attribute :published_at, item.reviewed_at
        end 
      end }
    end
  end
end
