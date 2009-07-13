# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def days_for_select(current = nil)
    options = []
    %w(monday tuesday wednesday thursday friday saturday sunday).each_with_index { |element, idx| options << [element, idx + 1] }
    options_for_select(options, current)
  end

  def google_analytics
    return unless RAILS_ENV == 'production'
    '<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
    <script type="text/javascript">
    <!--
    _uacct = "UA-694051-1";
    urchinTracker();
    -->
    </script>'
  end

  def random_sidebar
    @sidebar_title, @sidebar_locations = Sidebar.random
    render :partial => 'shared/sidebar'
  end
  
  def select_zip
    select('location', 'zip', Location.zip_codes.collect { |p| p.zip }, { :prompt => '--Zip Code--' } )
  end
  
  def midpoint(values)
    difference = values.first - values.last
    values.last + difference/2
  end
  
  def my_select_time(datetime = Time.now, options = {})
    hour_options = options.clone
    hour_options[:field_name] += '(1i)'
    minute_options = options.clone
    minute_options[:field_name] += '(2i)'
    minute_options[:minute_step] = 15
    h = select_hour(datetime, hour_options) + select_minute(datetime, minute_options)
  end
end
