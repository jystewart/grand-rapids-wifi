# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 23) do

  create_table "aspects", :force => true do |t|
    t.string   "name",       :limit => 31
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.timestamp "created_at",                                              :null => false
    t.string    "title"
    t.string    "uri"
    t.string    "blog_name"
    t.text      "excerpt",          :limit => 16777215
    t.string    "user_ip",          :limit => 15
    t.boolean   "trackback"
    t.boolean   "hide",                                 :default => false
    t.string    "commentable_type"
    t.integer   "commentable_id"
    t.boolean   "sent_to_akismet"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["hide"], :name => "index_comments_on_hide"

  create_table "geocodes", :force => true do |t|
    t.decimal "latitude",    :precision => 15, :scale => 12
    t.decimal "longitude",   :precision => 15, :scale => 12
    t.string  "query"
    t.string  "street"
    t.string  "locality"
    t.string  "region"
    t.string  "postal_code"
    t.string  "country"
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
    t.string    "name"
    t.string    "street"
    t.string    "city"
    t.string    "state",        :limit => 2
    t.string    "zip",          :limit => 10
    t.text      "description"
    t.string    "url"
    t.string    "status",       :limit => 10
    t.string    "visibility",   :limit => 3,   :default => "no", :null => false
    t.timestamp "created_at",                                    :null => false
    t.string    "email",        :limit => 128
    t.string    "permalink",    :limit => 32
    t.string    "ssid",         :limit => 32
    t.boolean   "free"
    t.string    "phone_number", :limit => 20
    t.datetime  "updated_at"
    t.string    "country"
  end

  add_index "locations", ["permalink"], :name => "index_locations_on_slug"
  add_index "locations", ["permalink"], :name => "slug", :unique => true
  add_index "locations", ["permalink"], :name => "slug_3"
  add_index "locations", ["visibility"], :name => "index_locations_on_visibility"

  create_table "locations_neighbourhoods", :id => false, :force => true do |t|
    t.integer "neighbourhood_id"
    t.integer "location_id"
  end

  create_table "neighbourhoods", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.string   "headline"
    t.text     "content",    :limit => 16777215
    t.string   "external"
    t.datetime "created_at"
    t.text     "extended",   :limit => 16777215
    t.string   "permalink",  :limit => 32
    t.integer  "user_id"
  end

  add_index "news", ["permalink"], :name => "index_news_on_slug"
  add_index "news", ["permalink"], :name => "slug", :unique => true

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

  create_table "pings", :force => true do |t|
    t.integer  "pingable_id"
    t.string   "pingable_type"
    t.datetime "created_at"
    t.integer  "notifiable_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login"

  create_table "votes", :force => true do |t|
    t.integer   "location_id", :limit => 2
    t.integer   "rating",      :limit => 1
    t.string    "voter",       :limit => 15
    t.timestamp "created_at",                :null => false
    t.integer   "aspect_id"
  end

  add_index "votes", ["location_id"], :name => "vote_location"

end
