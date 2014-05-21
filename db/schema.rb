# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140509043458) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_authors", force: true do |t|
    t.integer  "author_id"
    t.integer  "article_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_authors", ["article_id"], name: "index_article_authors_on_article_id", using: :btree

  create_table "articles", force: true do |t|
    t.string   "title"
    t.integer  "creator_id"
    t.text     "body"
    t.integer  "editor_id"
    t.datetime "edited_at"
    t.date     "date"
    t.datetime "responded_at"
    t.datetime "finalized_at"
    t.integer  "column_id"
    t.string   "status"
    t.boolean  "finalized"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_old"
    t.text     "byline"
    t.boolean  "published"
    t.datetime "published_at"
    t.string   "image"
    t.boolean  "needs_rewrite"
    t.boolean  "created"
    t.boolean  "edited"
    t.integer  "status_order_by"
    t.integer  "topic_id"
    t.boolean  "reviewed",        default: false, null: false
    t.integer  "reviewer_id"
  end

  add_index "articles", ["topic_id"], name: "index_articles_on_topic_id", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "columns", force: true do |t|
    t.string   "column"
    t.string   "short_name"
    t.integer  "columnist_id"
    t.integer  "articles_count",     default: 0, null: false
    t.integer  "days_between_posts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "publish_days"
    t.date     "start_date"
    t.string   "image"
    t.text     "description"
    t.boolean  "active"
    t.string   "article_append"
    t.string   "display_name"
  end

  create_table "comments", force: true do |t|
    t.integer  "commentable_id",   default: 0
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",          default: 0, null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "credits", force: true do |t|
    t.integer  "movie_id"
    t.integer  "name_variant_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credits", ["movie_id"], name: "index_credits_on_movie_id", using: :btree
  add_index "credits", ["name_variant_id"], name: "index_credits_on_name_variant_id", using: :btree

  create_table "daily_videos", force: true do |t|
    t.string   "title"
    t.string   "source"
    t.date     "date"
    t.integer  "reviewer_id"
    t.datetime "reviewed_at"
    t.boolean  "reviewed"
    t.integer  "creator_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.datetime "published_at"
  end

  create_table "dudes", force: true do |t|
    t.string   "name"
    t.integer  "quotes_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.text     "event"
    t.string   "link"
    t.date     "date"
    t.integer  "reviewer_id"
    t.datetime "reviewed_at"
    t.boolean  "reviewed"
    t.integer  "creator_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "month_day"
  end

  create_table "facts", force: true do |t|
    t.text     "fact"
    t.integer  "creator_id"
    t.string   "nickname"
    t.integer  "reviewer_id"
    t.boolean  "reviewed"
    t.datetime "reviewed_at"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "genres", force: true do |t|
    t.string   "genre"
    t.text     "description"
    t.integer  "movies_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "models", force: true do |t|
    t.string   "model"
    t.integer  "owner_id"
    t.date     "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "models", ["owner_id"], name: "index_models_on_owner_id", using: :btree

  create_table "movie_genres", force: true do |t|
    t.integer  "movie_id"
    t.integer  "genre_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movie_genres", ["genre_id"], name: "index_movie_genres_on_genre_id", using: :btree
  add_index "movie_genres", ["movie_id"], name: "index_movie_genres_on_movie_id", using: :btree

  create_table "movies", force: true do |t|
    t.string   "title"
    t.date     "release_date"
    t.integer  "ratings_count",    default: 0, null: false
    t.decimal  "total_rating"
    t.integer  "reviewed_ratings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
  end

  create_table "name_variants", force: true do |t|
    t.string   "name_variant"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", force: true do |t|
    t.string   "position"
    t.string   "image"
    t.text     "description"
    t.date     "date"
    t.integer  "reviewer_id"
    t.datetime "reviewed_at"
    t.boolean  "reviewed"
    t.integer  "creator_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.datetime "published_at"
  end

  create_table "quotes", force: true do |t|
    t.text     "quote"
    t.integer  "dude_id"
    t.text     "context"
    t.integer  "year"
    t.string   "source"
    t.date     "date"
    t.integer  "creator_id"
    t.integer  "reviewer_id"
    t.datetime "reviewed_at"
    t.boolean  "reviewed"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.datetime "published_at"
  end

  add_index "quotes", ["dude_id"], name: "index_quotes_on_dude_id", using: :btree

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "ratings", force: true do |t|
    t.integer  "creator_id"
    t.decimal  "rating"
    t.text     "body"
    t.integer  "reviewer_id"
    t.datetime "reviewed_at"
    t.boolean  "reviewed"
    t.text     "notes"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rich_rich_files", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rich_file_file_name"
    t.string   "rich_file_content_type"
    t.integer  "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.text     "uri_cache"
    t.string   "simplified_type",        default: "file"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "taglines", force: true do |t|
    t.string   "tagline"
    t.integer  "creator_id"
    t.boolean  "reviewed"
    t.text     "notes"
    t.integer  "reviewer_id"
    t.datetime "reviewed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "thing_categories", force: true do |t|
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "things", force: true do |t|
    t.string   "thing"
    t.string   "image_old"
    t.text     "description"
    t.date     "date"
    t.integer  "thing_category_id"
    t.integer  "reviewer_id"
    t.datetime "reviewed_at"
    t.boolean  "reviewed"
    t.integer  "creator_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.datetime "published_at"
    t.string   "image"
  end

  add_index "things", ["thing_category_id"], name: "index_things_on_thing_category_id", using: :btree

  create_table "tips", force: true do |t|
    t.text     "tip"
    t.date     "date"
    t.integer  "reviewer_id"
    t.datetime "reviewed_at"
    t.boolean  "reviewed"
    t.integer  "creator_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.datetime "published_at"
  end

  create_table "titles", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "titles", ["user_id"], name: "index_titles_on_user_id", using: :btree

  create_table "topics", force: true do |t|
    t.string   "topic"
    t.text     "description"
    t.integer  "articles_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",               default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "role"
    t.integer  "tips_count",             default: 0,  null: false
    t.integer  "events_count",           default: 0,  null: false
    t.integer  "things_count",           default: 0,  null: false
    t.integer  "positions_count",        default: 0,  null: false
    t.integer  "daily_videos_count",     default: 0,  null: false
    t.integer  "articles_count",         default: 0,  null: false
    t.integer  "movies_count",           default: 0,  null: false
    t.integer  "ratings_count",          default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "byline"
    t.integer  "quotes_count",           default: 0,  null: false
    t.integer  "taglines_count",         default: 0,  null: false
    t.string   "avatar"
    t.text     "bio"
    t.string   "twitter_handle"
    t.integer  "comments_count",         default: 0,  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
