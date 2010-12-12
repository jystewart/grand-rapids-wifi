class DeviseCreateAdministrators < ActiveRecord::Migration
  def self.up
    create_table(:administrators) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      
      t.string :name

      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :administrators, :email,                :unique => true
    add_index :administrators, :reset_password_token, :unique => true
    # add_index :administrators, :confirmation_token,   :unique => true
    # add_index :administrators, :unlock_token,         :unique => true
    
    rename_column :news, :user_id, :administrator_id
  end

  def self.down
    rename_column :news, :administrator_id, :user_id
    drop_table :administrators
  end
end