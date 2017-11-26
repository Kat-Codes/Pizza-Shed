require 'erb'
require 'sinatra'
require 'sqlite3'
require './signUpController.rb'
require './addPizza.rb'
require './site.rb'
require './sessionController.rb'
require './myAccount.rb'
require './deletePizza.rb'
require './accountManagerController.rb'

include ERB::Util
enable :sessions
set :session_secret, 'super secret'

before do
    @menu_db = SQLite3::Database.new 'database/menu.sqlite'
end

get '/menu' do
    redirect '/admin' unless !session[:admin]
    if (session[:admin])
        puts "admin login hjgfdsa"
    else 
        puts "not admin sdfg"
    end
    puts "menu page"
    query = %{SELECT *
              FROM newMenu}
    @results = @menu_db.execute query
    
    erb :menu
end