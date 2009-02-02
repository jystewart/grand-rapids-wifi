require File.dirname(__FILE__) + '/../test_helper'
require 'admin_notifier'

class AdminNotifierTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end

  def test_submission_email
    location = Location.new({:status => 1, :zip => 49503, :permalink => 'my-test-location', :name => 'My Test Location', :street => 'Near My House'})
    submitter = Submitter.new({:name => 'James Stewart', :email => 'james@jystewart.net', :connection => 'None, really'})
    result = AdminNotifier.create_submission(location, submitter)
    assert_equal 'Hotspot Submission For GRWiFi', result.subject
    assert_equal 'james@grwifi.net', result.to[0]
    assert_match /Near My House  49503/, result.body
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/admin_notifier/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
