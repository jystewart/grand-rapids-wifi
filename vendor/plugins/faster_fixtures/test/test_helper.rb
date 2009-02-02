ENV['RAILS_ENV'] ||= 'mysql'
require File.dirname(__FILE__) + '/rails_root/config/environment.rb'
 
# Load the testing framework
require 'test_help'
silence_warnings { RAILS_ENV = ENV['RAILS_ENV'] }
 
# Run the migrations
ActiveRecord::Migrator.migrate("#{RAILS_ROOT}/db/migrate")
 
# Setup the fixtures path
require 'active_record'
require 'active_record/base'
require 'active_record/fixtures'
 
Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

require 'faster_fixtures' 
class Test::Unit::TestCase #:nodoc:

  def create_fixtures(*table_names)
    if block_given?
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names) { yield }
    else
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names)
    end
  end
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end
