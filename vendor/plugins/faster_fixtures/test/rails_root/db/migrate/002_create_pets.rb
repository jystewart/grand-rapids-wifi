class CreatePets < ActiveRecord::Migration
  def self.up
    create_table :pets do |t|
      t.column :person_id, :integer
      t.column :name, :string
      t.column :species, :string
    end
  end

  def self.down
    drop_table :pets
  end
end
