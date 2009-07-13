class SearchController < ApplicationController
  caches_page :index

  def results
    if params[:open] == 'now'
      @locations = Location.open_now
    else
      params[:q] ||= '*'
      params[:location] ||= {}
      params[:location][:zip] ||= params[:zip]
      opts = {:with => {}}
      
      if params[:location][:zip]
        opts[:with][:zip] = params[:location][:zip]
      end
      
      unless params[:location][:address].blank?
        from = Geocode.geocoder.locate(params[:location][:address]).coordinates.map(&:to_radians)
        opts[:geo] = from
        opts[:with]['@geodist'] = 0.0..(10 * 1610.0)
      end
      
      opts[:with][:free] = 1 if params[:location][:free]
      
      @locations = Location.search params[:q], opts
    end
    
    if params[:format] and params[:format] == 'map'
      build_map @locations
      response.headers['Content-Type'] = 'text/html; charset=utf-8'
      render and return
    end
    
    respond_to do |wants|
      wants.html
      wants.json { render :json => @locations.to_json }
      wants.xml { render :xml => @locations.to_xml(:include => :openings) }
    end

  end  
end
