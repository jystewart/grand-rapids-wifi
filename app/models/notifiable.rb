# == Schema Information
#
# Table name: notifiables
#
#  id       :integer(4)      not null, primary key
#  name     :string(255)
#  endpoint :string(255)
#

class Notifiable < ActiveRecord::Base
  has_many :pings
end
