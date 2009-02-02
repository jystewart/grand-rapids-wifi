class CreatePings < ActiveRecord::Migration
  def self.up
    create_table :pings do |t|
      t.column :pingable_id, :integer
      t.column :pingable_type, :string
      t.column :created_at, :datetime
      t.column :notifiable_id, :integer
    end
  end

  def self.down
    drop_table :pings
  end
end
