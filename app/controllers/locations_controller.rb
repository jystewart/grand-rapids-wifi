class LocationsController < InheritedResources::Base
  before_filter :authenticate_administrator!, :except => [:index, :map, :show, :feed, :rdf, :view]
  before_filter :load_location, :except => [:index, :list, :map, :create, :new]

  layout 'admin', :only => [:view, :feed, :list]

  cache_sweeper :location_sweeper
  # caches_page :index
  caches_page :map
  caches_page :show
  
  def index
    redirect_to :action => 'map' and return unless params[:display].nil? or params[:display] != 'map'

    per_page = request.format.rdf? ? 300 : 25

    @locations = Location.to_list.paginate :per_page => per_page, :page => params[:page]
    @entries = @locations

    respond_to do |wants|
      wants.html
      wants.json { render :json => @locations.to_json }
      wants.xml { render :xml => @locations.to_xml }
      wants.atom { render :layout => false }
      wants.rdf { render :layout => false }
      wants.rss { redirect_to locations_url(:format => :atom), :status => 301 }
    end
  rescue WillPaginate::InvalidPage
    redirect_to locations_url(:page => 1)
  end
  
  def list
    @locations = Location.paginate :per_page => 30, :order => 'name', :page => params[:page]
    render :layout => 'admin'
  end

  def map
    @locations = Location.active.visible.order('name').includes(:geocoding).reject { |l| l.geocoding.nil? }
    build_map @locations unless @locations.nil?
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
  
  private
  def load_location
    if params[:id] and params[:id].match(/^\d+$/)
      @location = Location.find(params[:id])
      if params[:format] and params[:format] != 'html'
        redirect_to location_url(@location, :format => params[:format]), :status => 301 and return
      else
        redirect_to location_url(@location), :status => 301 and return
      end
    elsif params[:id]
      conditions = {:permalink => params[:id]}
      conditions[:status] = ['proven', 'rumored', 'closed'] unless administrator_signed_in?
      @location = Location.first(:conditions => conditions, :include => [:geocoding, :neighbourhoods, :openings])
    end
    
    render_404 if @location.nil?
  end
end
