class CommentCounters < ActiveRecord::Migration
  def self.up
    add_column :locations, :comments_count, :integer, :null => false, :default => 0
    add_column :news, :comments_count, :integer, :null => false, :default => 0
    
    Location.find_each do |l|
      Location.update_counters l.id, :comments_count => l.comments.count
    end
    
    News.find_each do |n|
      News.update_counters n.id, :comments_count => n.comments.count
    end
  end

  def self.down
    remove_column :locations, :comments_count
  end
end
