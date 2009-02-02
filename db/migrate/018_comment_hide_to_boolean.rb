class CommentHideToBoolean < ActiveRecord::Migration
  def self.up
    change_column :comments, :hide, :boolean
  end

  def self.down
    change_column :comments, :hide, :integer, :limit => 4
  end
end
