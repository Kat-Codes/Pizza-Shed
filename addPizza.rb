require 'sqlite3'
require 'sinatra'
require 'erb'
require './signUpController.rb'
require './deletePizza.rb'
require './site.rb'
require './sessionController.rb'
require './myAccount.rb'
require './menu_controller.rb'
require './accountManagerController.rb'


include ERB::Util
enable :sessions
set :session_secret, 'super secret'



##Finds the database


before do
    @menu_db = SQLite3::Database.new 'database/menu.sqlite'
end


get '/addToMenu' do
	@submitted_pizza = false
	erb :addToMenu
end

post '/addToMenu' do
	@submitted_pizza = true
      
	##Values get sanitized
	@pizzaname = params[:pizzaname].strip
	@description = params[:description].strip
	@price = params[:price].strip
    @url = params[:url].strip
    
    ##Simple validation
	@pizzaname_ok = !@pizzaname.nil? && @pizzaname != ""
	@description_ok = !@description.nil? && @description != ""	
    @price_ok = !@price.nil? && @price != ""
    @url_ok = !@url.nil? && @url != ""
	@all_ok = @pizzaname_ok && @description_ok && @price_ok && @url_ok
    
	##Push to database
    if @all_ok              
        
        id = @menu_db.get_first_value 'SELECT MAX(id)+1 FROM newMenu'
        
        @menu_db.execute(
         'INSERT INTO newMenu VALUES (?,?,?,?,?)',
         [id, @pizzaname, @price, @description, @url])  
        erb :homepage
      ##add a page to send to
    end
    
	erb :addToMenu
end
