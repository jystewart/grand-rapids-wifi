module LocationsHelper
  def time_format(field)
    return field.strftime("%I:%M %p").downcase.sub(/^0/, '')
  end
  
  def bus_routes(routes)
    result = routes.collect do |route|
      link_to('Route ' + route.number.to_s, "http://www.ridetherapid.org/ride/routes/#{route.number}")
    end
    result.to_sentence
  end
  
  def location_link(location)
    url = location.url.match(/^http/) ? location.url : "http://#{location.url}"
    link_to truncate(url, :length => 40), url, :class => 'url'
  end
  
  def select_neighbourhood(location, index)
    @neighbourhood_list ||= Neighbourhood.find(:all).collect { |n| [n.name, n.id] }
    options = options_for_select(@neighbourhood_list, location.neighbourhoods[index].id)
    select_tag "location[neighbourhoods][#{index}]", options
  end
  
  def setup_neighbourhoods
    if @location.neighbourhoods.empty?
      2.times { @location.neighbourhoods.build }
    end
  end
  
  def static_map_for(location)
    the_params = {
      :f => 'q',
      :z => 14,
      :iwloc => 'A',
      :hl => 'en',
      :size => '300x300',
      :maptype => 'roadmap',
      :sensor => true,
      :zoom => 14
    }
    
    
    if location.geocode
      the_params[:center] = "#{location.geocode.latitude},#{location.geocode.longitude}"
      the_params[:q] = "#{location.geocode.latitude},#{location.geocode.longitude}"
      the_params[:markers] = "size:large|color:red|#{location.geocode.latitude},#{location.geocode.longitude}"
    else
      the_params[:center] = location.full_address
      the_params[:q] = location.full_address
      the_params[:markers] = "size:large|color:red|#{location.full_address}"
    end

    content_tag(:div, :id => 'map') do
      link_to "http://maps.google.co.uk/maps?#{the_params.to_param}" do
        image_tag("http://maps.google.com/maps/api/staticmap?#{the_params.to_param}")
      end
    end
  end
end
