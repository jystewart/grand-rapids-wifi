# FasterFixtures
require 'mocha'
module FixtureAdditions
  module ClassMethods
    @@all_cached_fixtures = {}
    
    def reset_cache connection=ActiveRecord::Base.connection
      @@all_cached_fixtures[connection.object_id] = {}
    end
    
    def cache_for_connection connection
      @@all_cached_fixtures[connection.object_id] ||= {}
      @@all_cached_fixtures[connection.object_id]
    end
    
    def fixture_is_cached? connection, table_name
      cache_for_connection(connection)[table_name]
    end

    def cached_fixtures connection
      fixtures = cache_for_connection(connection).values
      fixtures.size > 1 ? fixtures : fixtures.first
    end

    def cache_fixtures connection, fixtures
      cache_for_connection(connection).merge! fixtures.index_by(&:table_name)
    end

    def create_fixtures_with_cache(fixtures_directory, table_names, class_names = {})
      table_names = [table_names].flatten.map { |n| n.to_s }
      connection = block_given? ? yield : ActiveRecord::Base.connection
      
      table_names = table_names.reject {|table_name| fixture_is_cached? connection, table_name}
      
      unless table_names.empty?
        fixtures = create_fixtures_without_cache( fixtures_directory, table_names, class_names) {connection}
        unless fixtures.nil?
          if fixtures.instance_of?(Fixtures)
            fixtures = [fixtures]
          end
          cache_fixtures connection, fixtures
        end
      end
      
      fixtures = cached_fixtures connection
    end
  end

  def self.included base
    base.extend ClassMethods
    base.class_eval do 
      class << self
        alias_method_chain :create_fixtures, :cache
      end
    end
  end
end

module Test
  module Unit
    class TestCase

      def freeze_now value=Time.now
        Time.stubs(:now).returns(value)
      end
      
      @@freeze_time = nil
      
      #The following is not nice. Tell me if you know how to fix this!
      #The root issue is that we need to override the setup method, but (like the one in fixtures.rb)
      #we need to cope with the fact that the person writing a test case might define a setup method
      #we don't want this to clobber our setup method.
      def self.method_added(method)
      end

      def setup_with_freeze
        @@freeze_time ||= Time.now.change :usec => 0
        freeze_now @@freeze_time if @@freeze_time
        setup_with_fixtures
      end   

      alias_method :setup, :setup_with_freeze

      def self.method_added(method)
        case method.to_s
        when 'setup'
          unless method_defined?(:setup_without_freeze)
            alias_method :setup_without_freeze, :setup
            define_method(:setup) do
              setup_with_freeze
              setup_without_freeze
            end
          end
        when 'teardown'
          unless method_defined?(:teardown_without_fixtures)
            alias_method :teardown_without_fixtures, :teardown
            define_method(:teardown) do
              teardown_without_fixtures
              teardown_with_fixtures
            end
          end
        end
      end
   
    end
  end
end
class Fixtures
  include FixtureAdditions
end