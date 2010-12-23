class RenameNewsToStories < ActiveRecord::Migration
  def self.up
    rename_table :news, :stories
    Comment.update_all ['commentable_type = ?', 'Story'], ['commentable_type = ?', 'News']
  end

  def self.down
    rename_table :stories, :news
    Comment.update_all ['commentable_type = ?', 'Story'], ['commentable_type = ?', 'News']
  end
end