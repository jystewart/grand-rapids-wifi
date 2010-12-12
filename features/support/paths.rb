module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the homepage/i
      root_path
    when /the (.+?) sign in page/
      send("new_#{$1}_session_path")
    when /the (.+?) sign up page/
      send("new_#{$1}_registration_path")
    when /the (.+?) new password page/
      send("new_#{$1}_password_path")
    
    # Add more page name => path mappings here
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end
 
World(NavigationHelpers)
