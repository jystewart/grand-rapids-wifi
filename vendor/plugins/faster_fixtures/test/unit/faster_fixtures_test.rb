require File.join(File.dirname(__FILE__), '../test_helper')

ActiveRecord::Base.connection.class.class_eval do
  cattr_accessor :query_count

  # Array of regexes of queries that are not counted against query_count
  @@ignore_list = [/^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^BEGIN/, /^ROLLBACK/, /^COMMIT/]

  alias_method :execute_without_query_counting, :execute
  def execute_with_query_counting(sql, name = nil, &block)
    self.query_count += 1 unless @@ignore_list.any? { |r| sql =~ r }
    execute_without_query_counting(sql, name, &block)
  end
end

class Test::Unit::TestCase
  def assert_queries(num = 1)
    ActiveRecord::Base.connection.class.class_eval do
      self.query_count = 0
      alias_method :execute, :execute_with_query_counting
    end
    yield
  ensure
    ActiveRecord::Base.connection.class.class_eval do
      alias_method :execute, :execute_without_query_counting
    end
    assert_equal num, ActiveRecord::Base.connection.query_count, "#{ActiveRecord::Base.connection.query_count} instead of #{num} queries were executed."
  end
end
#dummy test case to ensure fixtures are loaded
class DummyTestCase < Test::Unit::TestCase
  fixtures :pets, :people
  def teardown #these teardown & setup do nothing, but allow us to check that our method_added stuff has worked ok
  end
  def setup
  end
  
  def test_transactions_not_bust #if we don't have the call chain setup for teardown, odd stuff will happen
    assert_equal 3, Pet.count
    Pet.delete_all
  end
  
  def test_transactions_not_bust_second
    assert_equal 3, Pet.count
    Pet.delete_all
  end
  
end

class SecondTestCase < Test::Unit::TestCase
  fixtures :people

  def assert_no_queries(&block)
    assert_queries(0, &block)
  end

  def test_nothing
    assert Fixtures.fixture_is_cached?( ActiveRecord::Base.connection, 'pets')
    assert Fixtures.fixture_is_cached?( ActiveRecord::Base.connection, 'people')
  end
  
  def run(result)
    assert_no_queries do
      super result
    end
    assert_equal 'lassie', people(:bob).pets.first.name
  end
end

class ThirdTestCase < Test::Unit::TestCase
  fixtures :hobbies, :people
  
  def test_hobbies
    assert Fixtures.fixture_is_cached?( ActiveRecord::Base.connection, 'pets')
    assert Fixtures.fixture_is_cached?( ActiveRecord::Base.connection, 'hobbies')
    assert Fixtures.fixture_is_cached?( ActiveRecord::Base.connection, 'people')
  end
  def run(result)
    assert_queries(2) do #clear hobbies, load hobbies
      super result
    end
    assert hobbies(:tennis).people.include?(people(:bob))
  end  
end