class AddResetPasswordStuff < ActiveRecord::Migration
  def up
    add_column :administrators, :reset_password_sent_at, :datetime
  end

  def down
    remove_column :administrators, :reset_password_sent_at
  end
end
