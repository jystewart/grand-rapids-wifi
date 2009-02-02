module SearchHelper
  
  def map_empty?
    @locations.collect(&:geocode).compact.size == 0
  end
  
  def other_type
    # Build new query hash
    newparams = {}
    ['location', 'date', 'keywords'].each do |key|
      if params.has_key?(key)
        params.fetch(key).each do |h_key, value|
          newparams[key + "[" + h_key + "]"] = value if not value.nil?
        end
      end
    end

    # And now stringify that
    new_string = ''
    newparams.each do |key, value|
      new_string += '&amp;' + URI.escape(key) + '=' + URI.escape(value)
    end
    
    if not params['format'] or params['format'][0] != 'map'
      new_string += '&amp;' + 'format=map'
    else
      new_string += '&amp;' + 'format=html'
    end
    return new_string
  end
end
