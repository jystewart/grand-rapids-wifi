class VotesCreatedAt < ActiveRecord::Migration
  def self.up
    rename_column :votes, :entered_at, :created_at
  end

  def self.down
    rename_column :votes, :created_at, :entered_at
  end
end
