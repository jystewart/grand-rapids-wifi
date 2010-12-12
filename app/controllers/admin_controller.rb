class AdminController < ApplicationController
  layout 'admin'
  before_filter :authenticate_administrator!

  def index
    @location_count = Location.count
    @live_locations = Location.visible.count
    
    @comment_count = Comment.count
    @spam_comments = Comment.hidden.count
    
    @locations = Location.find_all_by_is_visible(false, :order => 'created_at DESC')
    @news = News.limit(5)
    @comments = Comment.limit(5).order('created_at desc')
  end
end
