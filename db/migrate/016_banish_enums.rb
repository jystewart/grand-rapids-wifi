class BanishEnums < ActiveRecord::Migration
  def self.up
    change_column :locations, :status, :string, :limit => 10
    add_column :news, :user_id, :integer

    News.find(:all).each do |story|
      story.update_attributes :user_id => User.find(:first).id
    end
    
    remove_column :news, :author
  end

  def self.down
    remove_column :news, :user_id
    add_column :news, :author,     :enum,     :limit => [:james], :default => :james, :null => false
  end
end
