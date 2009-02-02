class NewsController < ApplicationController
  
  before_filter :login_required, :only => ['new', 'create', 'edit', 'update', 'destroy'],
         :redirect_to => { :action => :index }
  before_filter :archive_list, :only => [:index, :archive, :story, :show]
  before_filter :load_story, :only => [:edit, :show, :destroy, :update]
  
  cache_sweeper :news_sweeper
  caches_page :index, :archive, :story, :show
  
  verify :params => [:month, :year], :only => :archive, :redirect_to => {:action => :index}

  # layout 'admin', :only => [:new, :index, :edit]
  
  def index
    @stories = News.paginate  :order => 'created_at DESC', :per_page => 10, :page => params[:page]
    
    respond_to do |wants|
      wants.atom { render :layout => false }
      wants.html
    end
  end
  
  def archive
    start = Time.utc(params[:year], params[:month])
    finish = start + 1.month
    @stories = News.find(:all, :order => 'created_at DESC', 
      :conditions => ['created_at BETWEEN ? AND ?', start.to_s(:db), finish.to_s(:db)])
  end

  def story
    redirect_to :action => 'show', :id => params[:id], :status => 301 and return
  end
  
  def show
  end

  def new
    @story = current_user.news.build
  end

  def create
    @story = current_user.news.build(params[:story])
    if @story.save
      flash[:notice] = 'Story was successfully created.'
      redirect_to :action => 'index' and return
    end
    
    render :action => 'new' and return
  end

  def update
    if @story.update_attributes(params[:news])
      flash[:notice] = 'News was successfully updated.'
      redirect_to :action => 'story', :id => @story.permalink and return
    end
    render :action => 'edit'
  end

  def destroy
    @story.destroy
    flash[:notice] = 'That story has been deleted'
    redirect_to :action => 'index' and return
  end
  
  private
  def load_story
    @story = News.find(:first, :conditions => {:permalink => params[:id]}, :include => 'comments')
    render_404 and return false if @story.nil?
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
