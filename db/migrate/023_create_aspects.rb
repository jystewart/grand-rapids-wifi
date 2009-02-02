class CreateAspects < ActiveRecord::Migration
  def self.up
    create_table :aspects do |t|
      t.string :name, :limit => 31
      t.timestamps 
    end
    add_column :votes, :aspect_id, :integer
    ['food and drink', 'service', 'connection', 'environment'].each { |piece| Aspect.create(:name => piece) }
  end

  def self.down
    drop_table :aspects
    remove_column :ratings, :aspect_id
  end
end
