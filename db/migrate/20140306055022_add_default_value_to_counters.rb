class AddDefaultValueToCounters < ActiveRecord::Migration

  def change
    Column.find_each do |column|
      Column.reset_counters(column.id, :articles)
    end
    Dude.find_each do |dude|
      Dude.reset_counters(dude.id, :quotes)
    end
    Genre.find_each do |genre|
      Genre.reset_counters(genre.id, :movies)
    end
    Movie.find_each do |movie|
      Movie.reset_counters(movie.id, :ratings)
    end
    Topic.find_each do |topic|
      Topic.reset_counters(topic.id, :articles)
    end
    User.find_each do |user|
      User.reset_counters(user.id, :tips, :events, :things, :positions,
                                    :daily_videos, :articles,
                                    :ratings, :quotes, :taglines)
    end

    change_column :columns, :articles_count, :integer, default: 0, null: false
    change_column :dudes, :quotes_count, :integer, default: 0, null: false
    change_column :genres, :movies_count, :integer, default: 0, null: false
    change_column :movies, :ratings_count, :integer, default: 0, null: false
    change_column :topics, :articles_count, :integer, default: 0, null: false
    change_column :users, :tips_count, :integer, default: 0, null: false
    change_column :users, :events_count, :integer, default: 0, null: false
    change_column :users, :things_count, :integer, default: 0, null: false
    change_column :users, :positions_count, :integer, default: 0, null: false
    change_column :users, :daily_videos_count, :integer, default: 0, null: false
    change_column :users, :articles_count, :integer, default: 0, null: false
    change_column :users, :movies_count, :integer, default: 0, null: false
    change_column :users, :ratings_count, :integer, default: 0, null: false
    change_column :users, :quotes_count, :integer, default: 0, null: false
    change_column :users, :taglines_count, :integer, default: 0, null: false
  end
end
