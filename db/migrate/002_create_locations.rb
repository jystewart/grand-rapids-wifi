class CreateLocations < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE wifi_locations RENAME TO locations"
    execute "ALTER TABLE wifi_comments RENAME TO comments"
    execute "ALTER TABLE wifi_votes RENAME TO votes"
    execute "ALTER TABLE wifi_news RENAME TO news"
  end

  def self.down
    execute "ALTER TABLE locations RENAME TO wifi_locations"
    execute "ALTER TABLE comments RENAME TO wifi_comments"
    execute "ALTER TABLE votes RENAME TO wifi_votes"
    execute "ALTER TABLE news RENAME TO wifi_news"
  end
end
