class GeocodePrecision < ActiveRecord::Migration
  def self.up
    add_column :geocodes, :precision, :string
  end

  def self.down
    remove_column :geocodes, :precision
  end
end
