class CreateNews < ActiveRecord::Migration
  def self.up
    create_table "wifi_news", :force => true do |t|
      t.column :headline,            :string, :limit => 255
      t.column :content,            :string
      t.column :external, :string, :limit => 255
      t.column :author,             :string, :limit => 40
      t.column :dated,       :datetime
      t.column :extended,       :string
      t.column :slug, :string, :limit => 32
    end
    create_table "wifi_locations", :force => true, :id => false do |t|
      t.column :wifi_locations_id, :integer
      t.column :wifi_locations_name, :string, :limit => 255
      t.column :wifi_locations_location, :string, :limit => 255
      t.column :wifi_locations_city, :string, :limit => 255
      t.column :wifi_locations_state, :string, :limit => 2
      t.column :wifi_locations_zip, :string, :limit => 10
      t.column :wifi_locations_blurb, :string
      t.column :wifi_locations_url, :string, :limit => 255
      t.column :wifi_locations_status, :string, :limit => 32
      t.column :wifi_locations_visible, :boolean
      t.column :adjusted, :datetime
      t.column :email, :string, :limit => 128
      t.column :sunday_open, :time
      t.column :sunday_close, :time
      t.column :monday_open, :time
      t.column :monday_close, :time
      t.column :tuesday_open, :time
      t.column :tuesday_close, :time
      t.column :wednesday_open, :time
      t.column :wednesday_close, :time
      t.column :thursday_open, :time
      t.column :thursday_close, :time
      t.column :friday_open, :time
      t.column :friday_close, :time
      t.column :saturday_open, :time
      t.column :saturday_close, :time
      t.column :longitude, :float
      t.column :latitude, :float
      t.column :slug, :string, :limit => 32
      t.column :ssid, :string, :limit => 32
      t.column :free, :boolean
    end
    create_table "wifi_comments" do |t|
      t.column :resource_id, :integer
      t.column :entered, :timestamp
      t.column :title, :string, :limit => 255
      t.column :uri, :string, :limit => 255
      t.column :blog_name, :string, :limit => 255
      t.column :excerpt, :string
      t.column :user_ip, :string, :limit => 255
      t.column :trackback, :boolean
      t.column :hide, :boolean
      t.column :resource_type, :string, :limit => 32
    end
    create_table "wifi_votes" do |t|
      t.column :wifi_location, :integer
      t.column :rating, :integer
      t.column :voter, :string, :limit => 15
      t.column :entered, :timestamp
    end
  end
  
  def self.down
    drop_table "wifi_news"
    drop_table "wifi_locations"
    drop_table "wifi_comments"
    drop_table "wifi_votes"    
  end
end