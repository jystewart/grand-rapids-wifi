source :gemcutter

gem "rails", "3.0.3"
gem 'mysql', '~> 2.8.1'

gem "flickraw"
gem "graticule"
gem 'will_paginate', '~> 3.0.pre2'

gem "delayed_job", '~> 2.0.0'
gem "thinking-sphinx", '~> 2.0.1'
gem 'ts-delayed-delta', '~> 1.1.0', :require => 'thinking_sphinx/deltas/delayed_delta'
gem 'hoptoad_notifier', '~> 2.4.2'
gem 'formtastic', '~> 1.2.0'
gem 'inherited_resources', '~> 1.1.2'
gem 'acts_as_geocodable', '~> 2.0.0'

gem 'devise', '~> 1.1.0'
gem 'friendly_id'

group :development do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'klgenerators', :git => 'https://github.com/jystewart/klgenerators.git'
end

group :test do
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'capybara'
  
  gem 'factory_girl'
  gem 'launchy'
  gem 'shoulda'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.2.0'  
end