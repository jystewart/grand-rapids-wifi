class LocationsController < ApplicationController
  verify :method => :post, :only => [ :comment, :rate, :destroy ], :redirect_to => { :action => :index }
  verify :params => :id, :only => [:view, :edit, :destroy], :redirect_to => {:action => :index}
  verify :params => :id, :only => :rate, :redirect_to => {:action => :index}
  verify :params => :vote, :only => :rate, :redirect_to => :back

  before_filter :login_required, :except => [:index, :map, :show, :feed, :rdf, :view]
  before_filter :load_location, :except => [:index, :list, :map, :create, :new]

  # layout 'admin', :only => [:view, :feed, :list]

  cache_sweeper :location_sweeper
  caches_page :index
  caches_page :map
  caches_page :show
  
  def index
    redirect_to :action => 'map' and return unless params[:display].nil? or params[:display] != 'map'

    per_page = request.format.rdf? ? 300 : 25

    @locations = Location.paginate :per_page => per_page, :order => 'name', :page => params[:page], 
      :conditions => ['visibility = ? AND status IN (?, ?)', 'yes', 'proven', 'rumored']
    
    @entries = @locations

    respond_to do |wants|
      wants.html
      wants.json { render :json => @locations.to_json }
      wants.xml { render :xml => @locations.to_xml }
      wants.atom { render :layout => false }
      wants.rdf { render :layout => false }
      wants.rss { redirect_to locations_url(:format => :atom), :status => 301 }
    end
  end
  
  def list
    @locations = Location.paginate :per_page => 30, :order => 'name', :page => params[:page]
    render :layout => 'admin'
  end

  def map
    @locations = Location.find_all_by_visibility('yes', 
      :conditions => ['status IN (?) ', ['proven', 'rumored']], 
      :order => 'name', :include => :geocoding).reject { |l| l.geocoding.nil? }
    build_map @locations unless @locations.nil?
  end
  
  def view
    params[:format] = params[:format] == 'rss' ? 'atom' : params[:format]
    redirect_to location_url(@location, :format => params[:format]), :status => 301
  end
  
  def show
    build_map [@location] if request.format.html?

    @average = { :total => @location.votes.count, :mean => @location.votes.average(:rating) }
    
    respond_to do |wants|
      wants.html
      wants.json { render :json => @locations.to_json }
      wants.xml { render :xml => @locations.to_xml }
      wants.atom { render :layout => false }
      wants.rdf { render :layout => false }
      wants.rss { redirect_to location_url(@location, :format => 'atom'), :status => 301 }
    end
  end
  
  def feed
    response.headers["Status"] = "301 Moved Permanently"
    redirect_to location_url(:id => params[:id], :format => :atom)
  end
  
  def rdf
    redirect_to :action => 'view', :id => params[:id], :format => 'rdf'
  end

  def new
    @location = Location.new
    render :layout => 'admin'
  end

  def create
    @location = Location.new(params[:location])
    if @location.save
      flash[:notice] = 'Location was successfully created.'
      redirect_to :action => 'index' and return
    end
    render :action => 'new', :layout => 'admin'
  end

  def edit
    render :layout => 'admin'
  end
  
  def update
    if @location.update_attributes(params[:location])
      flash[:notice] = 'Location was successfully updated.'
      redirect_to location_url(@location) and return
    end

    render :action => 'edit', :layout => 'admin'
  end

  def destroy
    @location.destroy
    flash[:notice] = 'Location successfully deleted'
    redirect_to :action => 'list'
  end
  
  private
  def load_location
    if params[:id] and params[:id].match(/^\d+$/)
      @location = Location.find(params[:id])
      if params[:format] and params[:format] != 'html'
        redirect_to location_url(@location, :format => params[:format]), :status => 301 and return
      else
        redirect_to location_url(@location), :status => 301 and return
      end
    elsif logged_in? and params[:id]
      @location = Location.find(:first, :conditions => {:permalink => params[:id]})
    else
      @location = Location.find(:first, 
        :conditions => ['permalink = ? AND status IN (?, ?, ?)', params[:id], 'proven', 'rumored', 'closed'])
    end
    
    render(:file => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found") if @location.nil?
  end
end
