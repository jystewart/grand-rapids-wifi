# == Schema Information
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  login                     :string(40)
#  email                     :string(100)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  encrypted_password        :string(128)
#  token                     :string(128)
#  token_expires_at          :datetime
#  email_confirmed           :boolean(1)      not null
#

class User < ActiveRecord::Base
  include Clearance::User
end
