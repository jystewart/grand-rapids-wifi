# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here

  # Activate observers that should always be running
  config.active_record.observers = :comment_observer

  config.action_controller.session = { :key => "_wifi_session", :secret => "52d375144e0f4b93437c0f4fc3f5158fgrand rapids 49503" }
end

# Include your application configuration below
HOST='grwifi.net'
DO_NOT_REPLY='donotreply@grwifi.net'