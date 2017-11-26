require 'sinatra'
require 'sqlite3'
require './signUpController.rb'
require './addPizza.rb'
require './addOffer.rb'
require './menu_controller.rb'
require './sessionController.rb'
require './deletePizza.rb'
require './myAccount.rb'
require './accountManagerController.rb'
require './twitter.rb'
require './orderDisplayController.rb'
require './questionDisplayController.rb'
require './tweetController.rb'

include ERB::Util
enable :sessions
set :session_secret, 'super secret'


set :bind, '0.0.0.0' 

$menu_db = SQLite3::Database.new("database/menu.sqlite")
$orders_db = SQLite3::Database.new("database/orders.sqlite")



get '/' do 
    redirect '/sheffield' unless !session[:sheffieldcustomer]
    redirect '/london' unless !session[:londoncustomer]
    redirect '/admin' unless !session[:admin]
    erb :homepage    
end

get '/tweet' do 
        redirect '/' unless session[:marketingAdmin]
    erb :tweet
end

get '/menu' do
    if [session[:admin]]
        puts "admin sesh"
    else 
        puts "not admin"
    end
    puts "menu sadff  page"
    redirect '/admin' unless !session[:admin]
    erb :menu
end

get '/london' do
    puts "london page"
    redirect '/' unless session[:londoncustomer]
    #special_offers() 
    erb :london
end

get '/sheffield' do
    redirect '/' unless session[:sheffieldcustomer]
    #special_offers() 
    erb :sheffield
end



get '/signup' do
    redirect '/' unless !session[:sheffieldcustomer] && !session[:londoncustomer] && !session[:admin]
    erb :signup    
end


get '/signedUp' do
    erb :signedUp
end

get '/login' do
    redirect '/' unless !session[:sheffieldcustomer] && !session[:londoncustomer] && !session[:admin]
    erb :login 
end

get '/logout' do    
    session.clear
#     session[:sheffieldcustomer] = false
#     session[:londoncustomer] = false
#     session[:admin] = false
    puts "user session = #{session[:username]}"
    if (!session[:admin])
        puts "cleared admin"
    end
    if (!session[:sheffieldcustomer] && !session[:londoncustomer])
        puts "clear customer"
    end
    
    erb :logout
end

get '/myAccount' do
    puts "my account"
    redirect '/' unless session[:sheffieldcustomer] || session[:londoncustomer]
    erb :myAccount
end
    

get '/addToMenu' do
    redirect '/' unless session[:menuAdmin]
    erb :addToMenu
    
end

get '/addOffer' do
    redirect '/' unless session[:admin]
    erb :addOffer
    
end


get '/accountManager' do
    redirect '/' unless session[:accountsAdmin]
    erb :accountManager
end

get '/orders' do
    redirect '/' unless session[:londonAdmin] || session[:sheffieldAdmin]
    twitter_loop($client) 
    erb :orders
end

get '/questions' do
    redirect '/' unless session[:londonAdmin] || session[:sheffieldAdmin]
    erb :questions
end


get '/admin' do
    puts "admin page"
    redirect '/' unless session[:admin]
    erb :admin
end

get '/deleteFromMenu' do
    redirect '/' unless session[:menuAdmin]
    erb :homepage
end

#get '/statusChange' do 
  #  query = %{SELECT *
  #            FROM ordersNew}
  #  @results = $orders_db.execute query 
 #   
 #   erb :orders
#end
