class CreateNotifiables < ActiveRecord::Migration
  def self.up
    create_table :notifiables do |t|
      t.column :name, :string
      t.column :endpoint, :string
    end
  end

  def self.down
    drop_table :notifiables
  end
end
