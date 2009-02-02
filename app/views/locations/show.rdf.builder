xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rdf :RDF, 
  'xmlns:review' => "http://amk.ca/xml/review/1.0#",
  'xmlns:rdf' => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
  'xmlns:geo' => "http://www.w3.org/2003/01/geo/wgs84_pos#",
  'xmlns:foaf' => "http://xmlns.com/foaf/0.1/",
  'xmlns:addr' => "http://www.w3.org/2000/10/swap/pim/contact#",
  'xmlns:wl' => "http://downlode.org/rdf/wireless/0.1/",
  'xmlns:rdfs' => "http://www.w3.org/2000/01/rdf-schema#" do

    xml.wl :Node, 'rdf:ID' => "grwifinet-#{@location.id}" do
      xml.foaf :homepage, location_url(@location)
      xml.wl :status, 'Operational'
      xml.wl :location do
        xml.addr :Address do
          xml.addr :Street, @location.street
          xml.addr :City, @location.city
          xml.addr :region, @location.state
          xml.addr :country, 'US'
          xml.addr :PostalCode, @location.zip
          unless @location.geocode.nil?
            xml.geo :lat, @location.geocode.latitude
            xml.geo :long, @location.geocode.longitude
          end
        end
      end
      
      if @location.email
        xml.wl :admin do
          xml.foaf :Person, 'rdf:ID' => "grwifinet-email-#{@location.email}" do
            xml.foaf :mbox, 'rdf:resource' => "mailto:#{@location.email}"
          end
        end
      end
      
      xml.wl :hasInterface do
        xml.wl :Interface do
          xml.wl :essid, @location.ssid
          xml.wl :linkLayer, '802.11b'
        end
      end
      
      for comment in @location.comments do
        xml.review :Review, 'rdf:ID' => "grwifi-comment-#{comment.id}" do
          xml.rdf :seeAlso, 'rdf:resource' => comment.uri if comment.uri
          xml.review :reviewer do
            xml.foaf :name, comment.blog_name
            xml.foaf :weblog, comment.uri if comment.uri
          end
          xml.rdfs :comment, comment.excerpt
        end
      end
    end
  end
