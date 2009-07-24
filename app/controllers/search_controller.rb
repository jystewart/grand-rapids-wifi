class SearchController < ApplicationController
  caches_page :index

  def results
    if params[:open] == 'now'
      @locations = Location.open_now
    else
      query, options = build_query
      options.merge!({:per_page => 15, :page => params[:page]})
      @locations = Location.search(query, options)
    end
    
    if @locations.empty?
      flash.now[:notice] = "Your search didn't return any results, please try again."
      render :action => 'index' and return
    end
    
    respond_to do |wants|
      wants.map {
        build_map @locations
        response.headers['Content-Type'] = 'text/html; charset=utf-8'
      }
      wants.html
      wants.atom
      wants.json { render :json => @locations.to_json }
      wants.xml { render :xml => @locations.to_xml(:include => :openings) }
    end
  end  
  
  protected
    def normalize_params
      params[:q] ||= ""
      params[:location] ||= {}
      params[:location][:zip] ||= params[:zip] if params[:zip]
    end
    
    def build_query
      normalize_params

      opts = {:with => {}}
      if params[:location][:zip]
        opts[:with][:zip] = params[:location][:zip]
        params[:q] << " #{params[:location][:zip]}"
      end
      
      unless params[:location][:address].blank?
        from = Geocode.geocoder.locate(params[:location][:address]).coordinates.map(&:to_radians)
        opts[:geo] = from
        opts[:with]['@geodist'] = 0.0..(10 * 1610.0)
      end
      
      if params[:q].blank? and params[:location][:zip]
        params[:q] = {:conditions => {:zip => params[:location][:zip]}}
      end
      
      opts[:with][:free] = 1 if params[:location][:free]
      return params[:q], opts
    end
end
