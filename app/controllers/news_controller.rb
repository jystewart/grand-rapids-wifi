class NewsController < InheritedResources::Base
  
  before_filter :authenticate_administrator!, :only => ['new', 'create', 'edit', 'update', 'destroy'],
         :redirect_to => { :action => :index }
  before_filter :archive_list, :only => [:index, :archive, :story, :show]
  before_filter :load_story, :only => [:edit, :show, :destroy, :update]
  
  cache_sweeper :news_sweeper
  caches_page :index, :archive, :story, :show

  # layout 'admin', :only => [:new, :index, :edit]
  
  def index
    @stories = News.paginate :per_page => 10, :page => params[:page]
    
    respond_to do |wants|
      wants.atom { render :layout => false }
      wants.html
    end
  end
  
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

    def archive_list
      months = News.find_by_sql('select distinct concat(year(created_at), \'-\', month(created_at)) as month 
        from news order by month desc')
      @archives = months.collect do |date|
        dates = date.month.split('-')
        {
          :name => Date::MONTHNAMES[dates[1].to_i] + ' ' + dates[0], 
          :year => dates[0],
          :month => sprintf('%02d', dates[1])
        }
      end
    end
end
