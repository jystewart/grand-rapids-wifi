class CreateSlugs < ActiveRecord::Migration
  class Story < ActiveRecord::Base
    set_table_name 'news'
    has_friendly_id :headline, :use_slug => true, :cache_column => 'permalink'
  end

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
    
    [Location, Story, Neighbourhood].each do |klass|
      klass.find_each do |k|
        if k.permalink.present?
          k.slugs.create!(:name => k.permalink)
        else
          k.save
        end
      end
    end
  end

  def self.down
    drop_table :slugs
  end
end
