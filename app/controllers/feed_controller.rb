class FeedController < ApplicationController
  #before_filter :discern_type
  caches_page :comments
  caches_page :locations
  caches_page :news
  caches_page :index

  def comments
    @entries = Comment.find(:all, :limit => 10, :conditions => 'hide = 0', :order => 'created_at DESC')
    respond_to do |wants|
      wants.html { redirect_to '/about/feeds' and return }
      wants.atom
      wants.rss
      wants.rdf
    end
  end

  def locations
    redirect_to :controller => 'news', :action => 'index', :format => 'atom', :status => 301 and return
  end
  
  def news
    redirect_to :controller => 'news', :action => 'index', :format => 'atom', :status => 301 and return
  end

  def index
    entries = Array.new
    entries.concat(Location.find(:all, :limit => 10, :order => 'updated_at DESC'))
    entries.concat(Comment.find(:all, :limit => 10, :conditions => 'hide = 0', :order => 'created_at DESC'))
    entries.concat(News.find(:all, :limit => 10, :order => 'created_at DESC'))
    @entries = entries.sort { |x, y| y.created_at <=> x.created_at }
    respond_to do |wants|
      wants.atom
      wants.rss
      wants.rdf { render :action => 'index_rss' }
    end
  end
end
