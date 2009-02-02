class LocationCountry < ActiveRecord::Migration
  def self.up
    add_column :locations, :country, :string
  end

  def self.down
    remove_column :locations, :country
  end
end
