# == Schema Information
#
# Table name: pings
#
#  id            :integer(4)      not null, primary key
#  pingable_id   :integer(4)
#  pingable_type :string(255)
#  created_at    :datetime
#  notifiable_id :integer(4)
#

class Ping < ActiveRecord::Base
  belongs_to :notifiable
  belongs_to :pingable, :polymorphic => true
end
