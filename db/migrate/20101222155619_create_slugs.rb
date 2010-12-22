class CreateSlugs < ActiveRecord::Migration
  def self.up
    create_table :slugs do |t|
      t.string :name
      t.integer :sluggable_id
      t.integer :sequence, :null => false, :default => 1
      t.string :sluggable_type, :limit => 40
      t.string :scope
      t.datetime :created_at
    end
    add_index :slugs, :sluggable_id
    add_index :slugs, [:name, :sluggable_type, :sequence, :scope], :name => "index_slugs_on_n_s_s_and_s", :unique => true
    
    Location.find_each do |l|
      l.slugs.create!(:name => l.permalink)
    end
    
    News.find_each do |n|
      n.slugs.create!(:name => n.headline)
    end
    
    Neighbourhood.find_each do |n|
      n.slugs.create!(:name => n.permalink)
    end
  end

  def self.down
    drop_table :slugs
  end
end
