class Relations < ActiveRecord::Migration
  def self.up
    rename_column :locations, :wifi_locations_id, :id
    rename_column :locations, :wifi_locations_name, :name
    rename_column :locations, :wifi_locations_location, :street
    rename_column :locations, :wifi_locations_city, :city
    rename_column :locations, :wifi_locations_state, :state
    rename_column :locations, :wifi_locations_zip, :zip
    rename_column :locations, :wifi_locations_blurb, :description
    rename_column :locations, :wifi_locations_url, :url
    rename_column :locations, :wifi_locations_status, :status
    rename_column :locations, :wifi_locations_visible, :visibility
    rename_column :votes, :wifi_location, :location_id
    rename_column :votes, :entered, :entered_at
  end

  def self.down
  end
end
