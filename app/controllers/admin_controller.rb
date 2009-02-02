class AdminController < ApplicationController
  layout 'admin'
  before_filter :login_required

  def index
    @location_count = Location.count
    @live_locations = Location.count "visibility = 'yes'"
    
    @comment_count = Comment.count
    @spam_comments = Comment.count 'hide = 1'
    
    @locations = Location.find_all_by_visibility('no', :order => 'created_at DESC')
    @news = News.find(:all, :limit => 5, :order => 'created_at desc')
    
    @comments = Comment.find(:all, :limit => 5, :order => 'created_at desc')
  end
end
