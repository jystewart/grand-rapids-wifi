xml.title entry.headline
xml.updated entry.created_at.xmlschema
xml.published entry.created_at.xmlschema
xml.author { 
  xml.name 'James Stewart'
  xml.uri 'http://jystewart.net'
  xml.email 'james@jystewart.net'
}
xml.id url_for(:only_path => false, :controller => 'news', :action => 'show', :id => entry.permalink)
xml.link "rel" => "alternate", "type" => "text/html", "href" => url_for(:only_path => false, :controller => 'news', :action => 'show', :id => entry.permalink)
xml.content :type => 'xhtml' do 
  xml.div :xmlns => 'http://www.w3.org/1999/xhtml' do
    xml.p entry.content
  end
end

xml.category :term => entry.headline
xml.category :term => SITE_NAME
xml.category :term => 'WiFi'
xml.category :term => 'Grand Rapids'
xml.category :term => 'Hotspots'
xml.category :term => 'Wireless Internet'