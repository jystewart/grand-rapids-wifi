require 'digest/sha1'
class User < ActiveRecord::Base
  include Clearance::User
end
