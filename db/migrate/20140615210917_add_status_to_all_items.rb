class Tip < ActiveRecord::Base
end

class Thing < ActiveRecord::Base
end

class DailyVideo < ActiveRecord::Base
end

class Quote < ActiveRecord::Base
end

class Position < ActiveRecord::Base
end

class Rating < ActiveRecord::Base
end

class Tagline < ActiveRecord::Base
end

class Fact < ActiveRecord::Base
end

class Event < ActiveRecord::Base
end

class AddStatusToAllItems < ActiveRecord::Migration
  def change
    publishable = [Tip, Thing, DailyVideo, Quote, Position]
    reviewable = publishable + [Tagline, Rating, Fact, Event]
    
    reviewable.each do |r|
      table_name = r.to_s.underscore.pluralize.to_sym
      add_column table_name, :needs_work, :boolean, default: false, null: false
      add_column table_name, :status, :string, default: '0 - Drafting', 
                             null: false
      add_column table_name, :status_order_by, :integer, default: 0, null: false

      r.reset_column_information
      reversible do |dir|
        dir.up { r.find_each do |item|
          if publishable.include?(r) && item.published?
            item.update_column :status, '3 - Published'
            item.update_column :published_at, item.date.midnight
          elsif item.reviewed?
            item.update_column :status, '2 - Reviewed'
          else
            item.update_column :status, '1 - Created'
          end
          item.update_column :status_order_by, item.status.to_i
          item.update_column :needs_work, false
        end }
      end
    end
  end
end
