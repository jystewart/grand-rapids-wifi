class DefaultVisibility < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE locations CHANGE COLUMN visibility visibility varchar(3) NOT NULL DEFAULT 'no'"
  end

  def self.down
    execute "ALTER TABLE locations CHANGE COLUMN visibility visibility enum('no', 'yes')"
  end
end
