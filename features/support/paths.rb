module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /the signup page/
      '/signup'
      
    when /the menu page/
      '/menu'
      
    when /the login page/
      '/login'
      
    when /the twitter page/
      '/ThePizzaShed'
        
    when /the add menu page/
        '/addToMenu'
        
    when /the order page/
        '/orders'
        
    when /the my account page/
        '/myAccount'
        
    when /the questions page/
        '/questions'
        
    when /the add account page/
        '/accountManager'
        
    when /the log out page/
        '/logout'
        
    when /the admin homepage/
        '/admin'
    
    when /the customer homepage/
        '/sheffield'
      
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"

    end
  end
end

World(NavigationHelpers)