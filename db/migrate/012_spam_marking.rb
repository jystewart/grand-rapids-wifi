class SpamMarking < ActiveRecord::Migration
  def self.up
    add_column :comments, :sent_to_akismet, :boolean
  end

  def self.down
    remove_column :comments, :sent_to_akismet, :boolean
  end
end
