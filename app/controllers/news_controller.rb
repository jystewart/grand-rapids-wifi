class NewsController < InheritedResources::Base
  
  before_filter :authenticate_administrator!, :only => ['new', 'create', 'edit', 'update', 'destroy'],
         :redirect_to => { :action => :index }
  before_filter :archive_list, :only => [:index, :archive, :story, :show]
  before_filter :load_story, :only => [:edit, :show, :destroy, :update]
  
  cache_sweeper :news_sweeper
  caches_page :index, :archive, :story, :show
  
  respond_to :html, :atom

  # layout 'admin', :only => [:new, :index, :edit]
  
  def archive
    start = Time.utc(params[:year], params[:month])
    finish = start + 1.month
    @stories = News.between(start, finish)
  end
  
  def show
    @story = News.find_by_permalink!(params[:id], :include => 'comments')
  end
  
  private
    def begin_of_association_chain
      current_administrator
    end
    
    def collection
      @stories ||= end_of_association_chain.paginate :per_page => 10, :page => params[:page]
    end

    def archive_list
      @archives = News.archives
    end
end
