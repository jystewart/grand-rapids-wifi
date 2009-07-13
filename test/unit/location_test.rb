# == Schema Information
#
# Table name: locations
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  street         :string(255)
#  city           :string(255)
#  state          :string(2)
#  zip            :string(10)
#  description    :text
#  url            :string(255)
#  status         :string(10)
#  visibility     :string(3)       default("no"), not null
#  created_at     :datetime        not null
#  email          :string(128)
#  permalink      :string(32)
#  ssid           :string(32)
#  free           :boolean(1)
#  phone_number   :string(20)
#  updated_at     :datetime
#  country        :string(255)
#  comments_count :integer(4)      default(0), not null
#

require File.dirname(__FILE__) + '/../test_helper'

class LocationTest < Test::Unit::TestCase
  fixtures :locations, :votes, :comments, :neighbourhoods

  def test_a_simple_search
    results = Location.search {}, {:hour => 21, :day => 'wednesday', :minute => 11}
    assert results
    assert results.is_a?(Array)
  end

  def test_should_have_comments
    cg = Location.find(46)
    assert_equal 17, cg.comments.size
    assert_equal Array, cg.comments.class
  end
  
  def test_should_have_votes
    cg = Location.find(46)
    assert_equal 9, cg.votes.size
    assert_equal Array, cg.votes.class
  end
  
  def test_should_require_name
    cg = Location.create(valid_location.except(:name))
    assert cg.errors.on(:name)
  end
  
  def test_should_require_zip
    cg = Location.create(valid_location.except(:zip))
    assert cg.errors.on(:zip)
  end
  
  def test_should_require_status
    cg = Location.create(valid_location.except(:status))
    assert cg.errors.on(:status)
  end
  
  def test_should_require_unique_permalink
    cg = Location.create(valid_location.merge(:permalink => 'common-ground'))
    assert cg.errors.on(:permalink)
  end
  
  def test_should_require_street
    cg = Location.create(valid_location.except(:street))
    assert cg.errors.on(:street)
  end
  
  def test_finds_recent_comments
    comments = Location.recent_comments
    assert_equal 5, comments.size
  end
  
  def test_finds_well_commented_hotspots
    comments = Location.most_comments
    assert_equal 5, comments.size
  end
  
  def test_finds_under_commented_hotspots
    comments = Location.least_comments
    assert_equal 5, comments.size
  end
  
  def test_finds_highly_rated_hotspots
    comments = Location.highly_rated
    assert_equal 5, comments.size
    assert comments.first.average > comments.last.average
  end

  # def test_finds_similar_hotspots
  #   similar = Location.find_similar('Common Ground')
  #   assert similar.first.name == 'Common Ground'
  # end
  
  def test_sets_up_neighbourhoods
    l = Location.find(:first)
    assert_difference "l.neighbourhoods.size", 2 do
      l.neighbourhoods = [1, 2]
    end
  end
  
  def test_creates_location_with_openings
    assert_difference "Opening.count", 7 do
      assert_difference "Location.count" do
        l = Location.create!(valid_location.merge("openings"=> {
            "0"=>{"opening_hour"=>"09", "opening_day"=>"1", "closing_hour"=>"22", "opening_minute"=>"00", "closing_day"=>"1", "closing_minute"=>"00"}, 
            "1"=>{"opening_hour"=>"09", "opening_day"=>"2", "closing_hour"=>"22", "opening_minute"=>"00", "closing_day"=>"2", "closing_minute"=>"00"}, 
            "2"=>{"opening_hour"=>"09", "opening_day"=>"3", "closing_hour"=>"22", "opening_minute"=>"00", "closing_day"=>"3", "closing_minute"=>"00"}, 
            "3"=>{"opening_hour"=>"09", "opening_day"=>"4", "closing_hour"=>"22", "opening_minute"=>"00", "closing_day"=>"4", "closing_minute"=>"00"}, 
            "4"=>{"opening_hour"=>"09", "opening_day"=>"5", "closing_hour"=>"23", "opening_minute"=>"00", "closing_day"=>"5", "closing_minute"=>"00"}, 
            "5"=>{"opening_hour"=>"09", "opening_day"=>"6", "closing_hour"=>"23", "opening_minute"=>"00", "closing_day"=>"6", "closing_minute"=>"00"}, 
            "6"=>{"opening_hour"=>"10", "opening_day"=>"7", "closing_hour"=>"20", "opening_minute"=>"00", "closing_day"=>"7", "closing_minute"=>"00"} 
          }))
      end
    end
  end
  
  private
    def valid_location
      {
        :visibility => 'yes', 
        :status => 'proven', 
        :name => 'My Test Location', 
        :permalink => 'my-test-location', 
        :street => 'Near My House',
        :zip => '49503',
        :country => 'US'
      }
      
    end
end
