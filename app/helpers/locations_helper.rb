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
    link_to truncate(url, 40), url, :class => 'url'
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
end
