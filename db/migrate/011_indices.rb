class Indices < ActiveRecord::Migration
  def self.up
    add_index :users, :login
    add_index :locations, :visibility
    add_index :locations, :slug
    add_index :news, :slug
    add_index :comments, :hide
    add_index :comments, [:commentable_id, :commentable_type]
  end

  def self.down
    remove_index :users, :login
    remove_index :locations, :visibility
    remove_index :locations, :slug
    remove_index :news, :slug
    remove_index :comments, :hide
    remove_index :comments, [:commentable_id, :commentable_type]
  end
end
