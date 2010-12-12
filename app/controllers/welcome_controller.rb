class WelcomeController < ApplicationController
  caches_page :index

  def index
    respond_to do |wants|
      wants.html { prepare_html }
      wants.atom { prepare_feed }
      wants.rss { prepare_feed }
      wants.rdf { prepare_feed }
    end
  end
  
  protected
    def prepare_html
      @locations = Location.latest_visible
      @stories = News.limit(2)
    end

    def prepare_feed
      entries = Array.new
      entries.concat(Location.find(:all, :limit => 10, :order => 'updated_at DESC'))
      entries.concat(Comment.find(:all, :limit => 10, :conditions => 'hide = 0', :order => 'created_at DESC'))
      entries.concat(News.find(:all, :limit => 10, :order => 'created_at DESC'))
      @entries = entries.sort { |x, y| y.created_at <=> x.created_at }
    end
end
