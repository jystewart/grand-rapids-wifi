# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here

  # Activate observers that should always be running
  config.active_record.observers = :comment_observer

  config.action_controller.session = { :session_key => "_wifi_session", :secret => "52d375144e0f4b93437c0f4fc3f5158fgrand rapids 49503" }
  
  # config.gem "flickraw"
  config.gem "graticule"
  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'thoughtbot-clearance', :lib => 'clearance', :source => 'http://gems.github.com', :version => '> 0.6.1'
  config.gem 'freelancing-god-thinking-sphinx', :lib => 'thinking_sphinx', :version => '1.1.23'
end

# Include your application configuration below
HOST='grwifi.net'
DO_NOT_REPLY='donotreply@grwifi.net'