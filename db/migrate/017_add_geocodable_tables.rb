class AddGeocodableTables < ActiveRecord::Migration
  def self.up
    
    drop_table :geocodes if ActiveRecord::Base.connection.tables.include?(:geocodes)
    drop_table :geocodings if ActiveRecord::Base.connection.tables.include?(:geocodings)
    
    create_table "geocodes" do |t|
      t.column "latitude", :decimal, :precision => 15, :scale => 12
      t.column "longitude", :decimal, :precision => 15, :scale => 12
      t.column "query", :string
      t.column "street", :string
      t.column "locality", :string
      t.column "region", :string
      t.column "postal_code", :string
      t.column "country", :string
    end

    add_index "geocodes", ["longitude"], :name => "geocodes_longitude_index"
    add_index "geocodes", ["latitude"], :name => "geocodes_latitude_index"
    add_index "geocodes", ["query"], :name => "geocodes_query_index", :unique => true

    create_table "geocodings" do |t|
      t.column "geocodable_id", :integer
      t.column "geocode_id", :integer
      t.column "geocodable_type", :string
    end

    add_index "geocodings", ["geocodable_type"], :name => "geocodings_geocodable_type_index"
    add_index "geocodings", ["geocode_id"], :name => "geocodings_geocode_id_index"
    add_index "geocodings", ["geocodable_id"], :name => "geocodings_geocodable_id_index"
    
    Location.find(:all).each do |l|
      l.visibility = 'yes' if l.visibility.blank?

      unless l.save
        puts l.visibility
        puts l.errors.inspect
      end

      unless l.geocode.nil?
        puts "#{l.name} : #{l.geocode.latitude} x #{l.geocode.longitude}"
      end
    end
    
    remove_column :locations, :latitude
    remove_column :locations, :longitude
  end

  def self.down
    drop_table  :geocodes
    drop_table  :geocodings
    add_column   :locations, :longitude, :decimal, :precision => 9, :scale => 7
    add_column   :locations, :latitude, :decimal, :precision => 9, :scale => 7
  end
end
