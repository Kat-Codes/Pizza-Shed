require 'sqlite3'
require 'sinatra'
require 'erb'
require './signUpController.rb'
require './addPizza.rb'
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


get '/deleteFromMenu' do
    @submitted = false
    erb :homepage
end


post '/deleteFromMenu' do 
    ##Sanitize values
    @pizzaID = params[:pizzaID].strip
        
    @menu_db.execute('DELETE FROM newMenu WHERE id = ? ', [@pizzaID])
    
    erb :addToMenu
end