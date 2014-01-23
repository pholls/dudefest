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

    # add_column :daily_videos, :published, :boolean
    # add_column :daily_videos, :published_at, :datetime
    # add_column :tip, :published, :boolean
    # add_column :tip, :published_at, :datetime
    # add_column :thing, :published, :boolean
    # add_column :thing, :published_at, :datetime
    # add_column :quote, :published, :boolean
    # add_column :quote, :published_at, :datetime

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
