module ErrorRenderers
  def render_404
    respond_to do |type|
      type.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found" }
      type.all  { render :nothing => true, :status => "404 Not Found" }
    end
  end

  def render_500
    respond_to do |type|
      type.html { render :file => "#{RAILS_ROOT}/public/500.html", :status => "500 Error" }
      type.all  { render :nothing => true, :status => "500 Error" }
    end
  end
  
  def render_403
    respond_to do |type|
      type.html { render :file => "#{RAILS_ROOT}/public/403.html", :status => "403 Forbidden" }
      type.all  { render :nothing => true, :status => "403 Forbidden" }
    end
  end
  
  def render_422
    respond_to do |type|
      type.html { render :file => "#{RAILS_ROOT}/public/422.html", :status => "422 Failed" }
      type.all  { render :nothing => true, :status => "422 Failed" }
    end
  end

end