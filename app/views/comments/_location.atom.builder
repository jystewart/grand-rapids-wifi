xml.id location_url(entry, :anchor => 'comment' + entry.id.to_s)
xml.title SITE_NAME + ': Comment on ' + entry.commentable.name
xml.link 'rel' => 'alternate', 'type' => 'text/html', 'href' => location_url(entry, :anchor => 'comment' + entry.id.to_s)
  
xml.content :type => 'xhtml' do 
  xml.div :xmlns => 'http://www.w3.org/1999/xhtml' do
    xml.p entry.blog_name + ' said regarding ' + entry.commentable.name + '...'
    xml.p entry.excerpt
  end
end

if entry.commentable.geocode
  xml.georss :point, :featuretypetag => 'wifi' do
		xml.text! entry.commentable.latitude.to_s + ' ' + entry.commentable.longitude.to_s
	end
end

xml.published entry.created_at.xmlschema

xml.category :term => entry.commentable.name
xml.category :term => 'WiFi'
xml.category :term => 'Grand Rapids'
xml.category :term => 'Hotspots'
xml.category :term => 'Wireless Internet'