xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.feed "xml:lang"=>"en-US", "xml:base"=>"http://#{controller.request.host}/", 
  "xmlns"=>"http://www.w3.org/2005/Atom", 
  "xmlns:dc" => "http://purl.org/dc/elements/1.1/", 
  "xmlns:geo" => 'http://www.w3.org/2003/01/geo/wgs84_pos#',
  'xmlns:georss' => 'http://www.georss.org/georss', 
  'xmlns:opensearch' => "http://a9.com/-/spec/opensearch/1.1/" do

  xml.title SITE_NAME + ": Search Results"
  xml.link "rel" => "alternate", "type" => "text/html", "href" => url_for(params.merge(:format => :html, :only_path => false))
  xml.link "rel" => "self", "type" => "application/atom+xml", "href" => url_for(params.merge(:format => :atom, :only_path => false))
  xml.rights "Creative Commons Attribution-NonCommercial-ShareAlike 2.0 http://creativecommons.org/licenses/by-nc-sa/2.0/ "

  xml.updated @locations.first.created_at.xmlschema unless @locations.empty?

  xml.tag!('openSearch:totalResults', @locations.total_entries)
  xml.tag!('opensearch:startIndex', @locations.offset + 1)
  xml.tag!('opensearch:itemsPerPage', @locations.per_page)
  xml.tag!('opensearch:Query', :role => 'request', :searchTerms => params[:q], :startPage => @locations.current_page)
  xml.tag!('opensearch:Url', :type => "application/atom+xml", :template => "#{search_results_url(:format => 'atom')}?q={searchTerms}&page={startPage}")
  
  @locations.compact.each do |location|
    xml.entry do
      xml << render(location)
    end
  end   
end
