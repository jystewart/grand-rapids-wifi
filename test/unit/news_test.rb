# == Schema Information
#
# Table name: news
#
#  id             :integer(4)      not null, primary key
#  headline       :string(255)
#  content        :text(16777215)
#  external       :string(255)
#  created_at     :datetime
#  extended       :text(16777215)
#  permalink      :string(32)
#  user_id        :integer(4)
#  comments_count :integer(4)      default(0), not null
#

require File.dirname(__FILE__) + '/../test_helper'

class NewsTest < Test::Unit::TestCase
  fixtures :news

  # Replace this with your real tests.
  def test_has_comments
    news = News.find(1)
    assert news
    assert news.comments
    assert_equal 0, news.comments.size
    assert_equal Array, news.comments.class
  end
  
  def test_requires_unique_permalink
    cg = News.create({:headline => "My Test Headline", :content => "Some text here", :user_id => 1})
    assert cg.errors.on(:permalink)
  end
  
  def test_requires_headline
    cg = News.create({:content => "Some text here", :permalink => 'my-test-story', :user_id => 1})
    assert cg.errors.on(:headline)
  end
  
  def test_requires_content
    cg = News.create({:headline => "My Test Headline", :permalink => 'my-test-story', :user_id => 1})
    assert cg.errors.on(:content)
  end
end
