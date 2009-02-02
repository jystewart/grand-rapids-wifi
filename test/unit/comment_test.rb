require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  fixtures :comments, :news

  def test_updated_at_equivalence
    comment = Comment.find(33)
    assert_equal comment.created_at, comment.updated_at
  end
  
  def test_requires_valid_ip_address
    c = Comment.new(:commentable_id => 1, :commentable_type => 'News', :excerpt => 'My excerpt')
    assert ! c.valid?
    c.user_ip = '12345'
    assert ! c.valid?
    c.user_ip = '355.255.255.1'
    assert ! c.valid?
    c.user_ip = '10.0.0.1'
    assert c.valid?
  end
  
  def test_requires_commentable_id
    c = Comment.new
    c.user_ip = '192.168.1.1'
    c.excerpt = 'My excerpt'
    assert ! c.save
  end

  def test_requires_valid_commentable_id
    assert_no_difference "Location.count" do
      c = Comment.create(:user_ip => '192.168.1.1', :excerpt => 'My excerpt', 
        :commentable_type => 'Location', :commentable_id => 12345)
    end
  end
  
  def test_requires_excerpt
    c = Comment.new
    c.commentable_id = 1
    c.user_ip = '192.168.1.1'
    assert ! c.save
  end
end
