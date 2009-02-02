class SlugToPermalink < ActiveRecord::Migration
  def self.up
    rename_column :locations, :slug, :permalink
    rename_column :news, :slug, :permalink
    rename_column :neighbourhoods, :slug, :permalink
  end

  def self.down
    rename_column :locations, :permalink, :slug
    rename_column :news, :permalink
    rename_column :neighbourhoods, :permalink, :slug
  end
end
