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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20180219124327) do

  create_table "administrators", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "password_salt",                         :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "reset_password_sent_at"
  end

  add_index "administrators", ["email"], :name => "index_administrators_on_email", :unique => true
  add_index "administrators", ["reset_password_token"], :name => "index_administrators_on_reset_password_token", :unique => true

  create_table "aspects", :force => true do |t|
    t.string   "name",       :limit => 31
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.datetime "created_at",                                              :null => false
    t.string   "title"
    t.string   "uri"
    t.string   "blog_name"
    t.text     "excerpt",          :limit => 16777215
    t.string   "user_ip",          :limit => 15
    t.boolean  "trackback"
    t.boolean  "hide",                                 :default => false
    t.string   "commentable_type", :limit => 24
    t.integer  "commentable_id"
    t.boolean  "sent_to_akismet"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["hide"], :name => "index_comments_on_hide"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.string   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "geocodes", :force => true do |t|
    t.decimal "latitude",    :precision => 15, :scale => 12
    t.decimal "longitude",   :precision => 15, :scale => 12
    t.string  "query"
    t.string  "street"
    t.string  "locality"
    t.string  "region"
    t.string  "postal_code"
    t.string  "country"
    t.string  "precision"
  end

  add_index "geocodes", ["latitude"], :name => "geocodes_latitude_index"
  add_index "geocodes", ["longitude"], :name => "geocodes_longitude_index"
  add_index "geocodes", ["query"], :name => "geocodes_query_index", :unique => true

  create_table "geocodings", :force => true do |t|
    t.integer "geocodable_id"
    t.integer "geocode_id"
    t.string  "geocodable_type"
  end

  add_index "geocodings", ["geocodable_id"], :name => "geocodings_geocodable_id_index"
  add_index "geocodings", ["geocodable_type"], :name => "geocodings_geocodable_type_index"
  add_index "geocodings", ["geocode_id"], :name => "geocodings_geocode_id_index"

  create_table "locations", :force => true do |t|
    t.string   "name",           :limit => 127
    t.string   "street",         :limit => 127
    t.string   "city"
    t.string   "state",          :limit => 2
    t.string   "zip",            :limit => 10
    t.text     "description"
    t.string   "url"
    t.string   "status",         :limit => 10
    t.datetime "created_at",                                       :null => false
    t.string   "email",          :limit => 128
    t.string   "permalink",      :limit => 32
    t.string   "ssid",           :limit => 32
    t.boolean  "free"
    t.string   "phone_number",   :limit => 20
    t.datetime "updated_at"
    t.string   "country"
    t.integer  "comments_count",                :default => 0,     :null => false
    t.boolean  "delta",                         :default => true,  :null => false
    t.boolean  "is_visible",                    :default => false
  end

  add_index "locations", ["name", "street"], :name => "ident"
  add_index "locations", ["name", "street"], :name => "idx"
  add_index "locations", ["name", "street"], :name => "name_street"
  add_index "locations", ["permalink"], :name => "slug", :unique => true
  add_index "locations", ["status"], :name => "index_locations_on_status"
  add_index "locations", ["updated_at"], :name => "index_locations_on_updated_at"
  add_index "locations", ["zip"], :name => "index_locations_on_zip"

  create_table "locations_neighbourhoods", :id => false, :force => true do |t|
    t.integer "neighbourhood_id"
    t.integer "location_id"
  end

  add_index "locations_neighbourhoods", ["neighbourhood_id"], :name => "index_locations_neighbourhoods_on_neighbourhood_id"

  create_table "neighbourhoods", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifiables", :force => true do |t|
    t.string "name"
    t.string "endpoint"
  end

  create_table "openings", :force => true do |t|
    t.integer "location_id"
    t.integer "opening_day"
    t.integer "closing_day"
    t.time    "opening_time"
    t.time    "closing_time"
  end

  add_index "openings", ["location_id"], :name => "index_openings_on_location_id"
  add_index "openings", ["opening_day"], :name => "index_openings_on_opening_day"

  create_table "pings", :force => true do |t|
    t.integer  "pingable_id"
    t.string   "pingable_type"
    t.datetime "created_at"
    t.integer  "notifiable_id"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "stories", :force => true do |t|
    t.string   "headline"
    t.text     "content",          :limit => 16777215
    t.string   "external"
    t.datetime "created_at"
    t.text     "extended",         :limit => 16777215
    t.string   "permalink",        :limit => 32
    t.integer  "administrator_id"
    t.integer  "comments_count",                       :default => 0, :null => false
  end

  add_index "stories", ["created_at"], :name => "index_news_on_created_at"
  add_index "stories", ["permalink"], :name => "index_news_on_slug"
  add_index "stories", ["permalink"], :name => "slug", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "encrypted_password",        :limit => 128
    t.string   "token",                     :limit => 128
    t.datetime "token_expires_at"
    t.boolean  "email_confirmed",                          :default => false, :null => false
    t.string   "confirmation_token",        :limit => 128
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "confirmation_token"], :name => "index_users_on_id_and_confirmation_token"
  add_index "users", ["id", "token"], :name => "index_users_on_id_and_token"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["token"], :name => "index_users_on_token"

  create_table "votes", :force => true do |t|
    t.integer  "location_id", :limit => 2
    t.integer  "rating",      :limit => 1
    t.string   "voter",       :limit => 15
    t.datetime "created_at",                :null => false
    t.integer  "aspect_id"
  end

  add_index "votes", ["location_id"], :name => "vote_location"

end
