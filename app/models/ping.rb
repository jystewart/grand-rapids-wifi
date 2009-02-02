class Ping < ActiveRecord::Base
  belongs_to :notifiable
  belongs_to :pingable, :polymorphic => true
end
