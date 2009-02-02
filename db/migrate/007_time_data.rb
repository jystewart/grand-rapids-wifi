class TimeData < ActiveRecord::Migration
  def self.up
    add_column :locations, :created_at, :datetime
    execute "UPDATE locations SET created_at = adjusted"
    remove_column :locations, :adjusted
    add_column :locations, :updated_at, :datetime
    execute "UPDATE locations SET updated_at = created_at"
    add_column :news, :created_at, :datetime
    execute "UPDATE news SET created_at = dated"
    remove_column :news, :dated
    execute "ALTER TABLE locations type=MyISAM"
    execute "CREATE FULLTEXT INDEX location_ident ON locations (name, street)"
  end

  def self.down
    rename_column :locations, :created_at, :adjusted
    remove_column :locations, :updated_at
    rename_column :news, :created_at, :dated
    execute "ALTER TABLE locations DROP INDEX location_ident"
  end
end
