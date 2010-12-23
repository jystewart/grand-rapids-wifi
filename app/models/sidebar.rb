class Sidebar
  @@options = {
    'highly_rated' => { :title => 'Most Highly Rated Hotspots', :method => :highly_rated },
    'least_comments' => { :title => 'Hotspots In Need Of Comments', :method => :least_comments },
    'most_comments' => { :title => 'Most Commented On Hotspots', :method => :most_comments },
    'recent_comments' => { :title => 'Recently Commented On', :method => :recent_comments }
  }
  @@used = []
  
  def self.random
    options = @@options.keys - @@used
    this_option = options[rand(options.size - 1)]
    @@used << this_option
    selected = @@options[this_option]
    if selected
      return selected[:title], Location.for_widgets.send(selected[:method], 5)
    else
      return nil
    end
  end
end