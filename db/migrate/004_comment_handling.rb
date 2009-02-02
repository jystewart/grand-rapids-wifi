class CommentHandling < ActiveRecord::Migration
  def self.up
    rename_column :comments, :resource_type, :type
    rename_column :comments, :entered, :created_at
  end

  def self.down
    rename_column :comments, :type, :resource_type
    rename_column :comments, :created_at, :entered
  end
end
