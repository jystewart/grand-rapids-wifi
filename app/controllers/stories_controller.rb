class StoriesController < InheritedResources::Base
  before_filter :authenticate_administrator!, :only => ['new', 'create', 'edit', 'update', 'destroy'],
         :redirect_to => { :action => :index }
  before_filter :archive_list, :only => [:index, :archive, :story, :show]

  cache_sweeper :news_sweeper
  caches_page :index, :archive, :story, :show

  respond_to :html, :atom

  # layout 'admin', :only => [:new, :index, :edit]

  def archive
    start = Time.utc(params[:year], params[:month])
    finish = start + 1.month
    @stories = Story.between(start, finish)
  end

  def show
    @story = Story.includes(:comments).friendly.find(params[:id])
  end

  private
    def build_resource
      current_administrator.stories.build
    end

    def collection
      @stories ||= Story.paginate :per_page => 10, :page => params[:page]
    end

    def archive_list
      @archives = Story.archives
    end
end
