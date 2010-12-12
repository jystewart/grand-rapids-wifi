class LocationIsVisible < ActiveRecord::Migration
  def self.up
    add_column :locations, :is_visible, :boolean, :default => false
    Location.reset_column_information
    Location.all.each do |l|
      l.is_visible = (l.visibility == 'yes')
      l.save
    end
  end

  def self.down
    remove_column :locations, :is_visible
  end
end