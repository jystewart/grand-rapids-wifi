ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
#require 'faster_fixtures'

class Test::Unit::TestCase

  # Add more helper methods to be used by all tests here...
  include AuthenticatedTestHelper

  def assert_valid_markup(markup = @response.body)
    Timeout::timeout(30) do
      require 'net/http'
      response = Net::HTTP.start('validator.w3.org') do |w3c|
        query = 'fragment=' + CGI.escape(markup) + '&output=xml'
        w3c.post2('/check', query)
      end
      assert_equal 'Valid', response['x-w3c-validator-status']
    end
  rescue
    return
  end
  
  def assert_flash_has(key=nil, message=nil) #:nodoc:
    msg = build_message(message, "<?> is not in the flash <?>", key, @response.flash)
    assert_block(msg) { @response.has_flash_object?(key) }
  end

  # ensure that the flash has no object with the specified name
  def assert_flash_has_no(key=nil, message=nil) #:nodoc:
    msg = build_message(message, "<?> is in the flash <?>", key, @response.flash)
    assert_block(msg) { !@response.has_flash_object?(key) }
  end

  # ensure the flash exists
  def assert_flash_exists(message=nil) #:nodoc:
    msg = build_message(message, "the flash does not exist <?>", @response.session['flash'] )
    assert_block(msg) { @response.has_flash? }
  end

  # ensure the flash does not exist
  def assert_flash_not_exists(message=nil) #:nodoc:
    msg = build_message(message, "the flash exists <?>", @response.flash)
    assert_block(msg) { !@response.has_flash? }
  end

  # ensure the flash is empty but existent
  def assert_flash_empty(message=nil) #:nodoc:
    msg = build_message(message, "the flash is not empty <?>", @response.flash)
    assert_block(msg) { !@response.has_flash_with_contents? }
  end

  # ensure the flash is not empty
  def assert_flash_not_empty(message=nil) #:nodoc:
    msg = build_message(message, "the flash is empty")
    assert_block(msg) { @response.has_flash_with_contents? }
  end

  def assert_flash_equal(expected = nil, key = nil, message = nil) #:nodoc:
    msg = build_message(message, "<?> expected in flash['?'] but was <?>", expected, key, @response.flash[key])
    assert_block(msg) { expected == @response.flash[key] }
  end
end