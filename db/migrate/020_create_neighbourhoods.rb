class CreateNeighbourhoods < ActiveRecord::Migration
  def self.up
    create_table :neighbourhoods do |t|
      t.string :name, :slug
      t.timestamps 
    end
    
    create_table :locations_neighbourhoods, :id => false do |t|
      t.integer :neighbourhood_id, :location_id
    end
  end

  def self.down
    drop_table :neighbourhoods
    drop_table :locations_neighbourhoods
  end
end
