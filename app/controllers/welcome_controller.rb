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
      @stories = Story.limit(2)
    end

    def prepare_feed
      entries = Array.new
      entries.concat(Location.limit(10).visible.order('updated_at DESC').all)
      entries.concat(Comment.limit(10).where(:hide => false).order('created_at DESC').all)
      entries.concat(Story.limit(10).order('created_at DESC').all)
      @entries = entries.sort { |x, y| y.created_at <=> x.created_at }
    end
end
