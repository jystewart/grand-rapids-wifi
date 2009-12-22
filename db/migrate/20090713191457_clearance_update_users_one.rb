class ClearanceUpdateUsersOne < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.string :encrypted_password, :limit => 128
      t.string :token, :limit => 128
      t.datetime :token_expires_at
      t.boolean :email_confirmed, :default => false, :null => false
    end
    
    add_index :users, [:id, :token]
    add_index :users, :email
    add_index :users, :token
  end
  
  def self.down
    change_table(:users) do |t|
      t.remove :encrypted_password,:token,:token_expires_at,:email_confirmed
    end
  end
end
