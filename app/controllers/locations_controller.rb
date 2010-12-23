class LocationsController < InheritedResources::Base
  before_filter :authenticate_administrator!, :except => [:index, :map, :show, :feed, :rdf, :view]
  before_filter :load_location, :except => [:index, :list, :map, :create, :new]

  layout proc { |c| [:edit, :create, :update, :view, :feed, :list].include?(params[:action].to_sym) ? 'admin' : 'application' }
  respond_to :html, :json, :xml, :atom, :rdf

  cache_sweeper :location_sweeper
  # caches_page :index
  caches_page :map
  caches_page :show
  
  def index
    redirect_to :action => 'map' and return unless params[:display].nil? or params[:display] != 'map'

    per_page = request.format.rdf? ? 300 : 25

    @locations = Location.to_list.paginate :per_page => per_page, :page => params[:page]
    @entries = @locations
    
    respond_with(@locations)
  rescue WillPaginate::InvalidPage
    redirect_to locations_url(:page => 1)
  end
  
  def list
    @locations = Location.paginate :per_page => 30, :page => params[:page]
    render :layout => 'admin'
  end

  def map
    @locations = Location.active.visible.includes(:geocoding).reject { |l| l.geocoding.nil? }
    build_map @locations unless @locations.nil?
  end
  
  def show
    build_map [@location] if request.format.html?

    @average = { :total => @location.votes.count, :mean => @location.votes.average(:rating) }
    
    respond_with(@location)
  end
  
  private
    def load_location
      if params[:id] and params[:id].match(/^\d+$/)
        @location = Location.find(params[:id])
        redirect_to location_url(@location, :format => params[:format]), :status => 301 and return
      elsif params[:id]
        scoped = Location.includes(:geocoding, :neighbourhoods, :openings)
        scoped = scoped.where(:status => %w(proven rumored closed)) unless administrator_signed_in?
        @location = scoped.find(params[:id])
      end
    
      render_404 if @location.nil?
    end
end
