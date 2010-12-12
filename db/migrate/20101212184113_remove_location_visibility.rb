class RemoveLocationVisibility < ActiveRecord::Migration
  def self.up
    remove_column :locations, :visibility
  end

  def self.down
    add_column :locations, :visibility, :string,     :limit => 3,   :default => "no", :null => false
  end
end
