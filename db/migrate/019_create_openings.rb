class CreateOpenings < ActiveRecord::Migration
  def self.up
    create_table :openings do |t|
      t.integer :location_id, :opening_day, :closing_day
      t.time :opening_time, :closing_time
    end
    
    Location.find(:all).each do |location|
      %w(monday tuesday wednesday thursday friday saturday sunday).each_with_index do |day, index|
        if location.send("#{day}_open") and location.send("#{day}_close")
          location.openings.create!(:opening_day => index + 1, :closing_day => index + 1, 
            :opening_time => location.send("#{day}_open"), :closing_time => location.send("#{day}_close"))
        end
      end
    end

    %w(monday tuesday wednesday thursday friday saturday sunday).each do |day|
      remove_column :locations, "#{day}_open"
      remove_column :locations, "#{day}_close"
    end
  end

  def self.down
    drop_table :openings
    %w(monday tuesday wednesday thursday friday saturday sunday).each do |day|
      add_column :locations, "#{day}_open", :time
      add_column :locations, "#{day}_close", :time
    end
  end
end
