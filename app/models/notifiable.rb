class Notifiable < ActiveRecord::Base
  has_many :pings
end
