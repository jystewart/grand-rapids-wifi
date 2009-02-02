xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.feed "xml:lang"=>"en-US", "xml:base"=>"http://#{controller.request.host}/", 
  "xmlns"=>"http://www.w3.org/2005/Atom", 
  "xmlns:dc" => "http://purl.org/dc/elements/1.1/", 
  "xmlns:geo" => 'http://www.w3.org/2003/01/geo/wgs84_pos#',
  'xmlns:georss' => 'http://www.georss.org/georss' do

  xml.title SITE_NAME + ": Comments On " + @location.name
  xml.id location_url(@location)
  xml.link "rel" => "alternate", "type" => "text/html", "href" => location_url(@location)
  xml.link "rel" => "self", "type" => "application/atom+xml", "href" => location_url(@location, :format => 'atom')
  xml.rights "Creative Commons Attribution-NonCommercial-ShareAlike 2.0 http://creativecommons.org/licenses/by-nc-sa/2.0/ "

  if @location.geocode
    xml.georss :point, @location.latitude.to_s + ' ' + @location.longitude.to_s
    xml.geo :lat, @location.latitude
    xml.geo :long, @location.longitude
  end

  xml.updated @location.comments.first.created_at.xmlschema unless @location.comments.empty?

  for entry in @location.displayable_comments.reverse

    xml.entry do
  
      xml << render(:partial => 'comments/location', :locals => {:entry => entry})

    end
  end   
end
