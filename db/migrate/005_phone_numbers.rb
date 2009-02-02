class PhoneNumbers < ActiveRecord::Migration
  def self.up
    add_column :locations, :phone_number, :string, :limit => 20
  end

  def self.down
    remove_column :locations, :phone_number
  end
end
