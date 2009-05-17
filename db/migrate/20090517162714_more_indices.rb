class MoreIndices < ActiveRecord::Migration
  def self.up
    add_index :locations, :zip
    add_index :locations, :status
    add_index :openings, :location_id
    add_index :openings, :opening_day
    add_index :locations_neighbourhoods, :neighbourhood_id
    
    change_column :comments, :commentable_type, :string, :limit => 24
    
    add_index :news, :created_at
    add_index :locations, :updated_at
  end

  def self.down
    remove_index :locations, :updated_at
    remove_index :news, :created_at
    change_column :comments, :commentable_type, :string
    remove_index :locations_neighbourhoods, :neighbourhood_id
    remove_index :openings, :opening_day
    remove_index :openings, :location_id
    remove_index :locations, :status
    remove_index :locations, :zip
  end
end
