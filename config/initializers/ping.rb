require 'sends_pings'

ActiveRecord::Base.class_eval do
  include KetLai::SendsPings
end
