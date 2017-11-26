require 'erb'
require 'sinatra'
require 'sqlite3'
require 'twitter'
require './signUpController.rb'
require './addPizza.rb'
require './site.rb'
require './sessionController.rb'
require './myAccount.rb'
require './deletePizza.rb'
require './accountManagerController.rb'
require './twitter.rb'

include ERB::Util
enable :sessions
set :session_secret, 'super secret'



before do
    @orders_db = SQLite3::Database.new 'database/orders.sqlite'
    @accounts_db = SQLite3::Database.new 'database/accounts.sqlite'
    
    
end

get '/orders' do
    twitter_loop($client)
    @sheffieldID = @accounts_db.execute('SELECT userID FROM customer WHERE city = "sheffield"')
    @sheffieldOrders = []
    @sheffieldID.each do |this|
        @sheffieldOrders += @orders_db.execute('SELECT * FROM orders WHERE userID =?', [this[0]]) 
    end
    
    @londonID = @accounts_db.execute('SELECT userID FROM customer WHERE city = "london"')
    @londonOrders = []
    @londonID.each do |this|
        @londonOrders += @orders_db.execute('SELECT * FROM orders WHERE userID =?', [this[0]]) 
    end
    
    erb :orders
end

post '/statusChange' do 
    @orderID = params[:orderID].strip
    @value = @orders_db.execute('SELECT orderStatus FROM orders WHERE orderID = ?', [@orderID])
    @userID = @orders_db.execute('SELECT userID FROM orders WHERE orderID = ?', [@orderID])
    @twitterHandle = @accounts_db.execute('SELECT twitterHandle FROM customer WHERE userID = ?', [@userID])
    @tweetID = @orders_db.execute('SELECT tweetID FROM orders WHERE orderID = ?', [@orderID])
    config = {
    :consumer_key => 'ynFt8TAqAKrEyNlqFghyHTv6D',
    :consumer_secret => 'uFsWYaUDALKc3ugrBrzteQG4P4jgZQoKPfYjddegzLoRfmZ5A2',
    :access_token => '833682097734815745-hY14gIao0fv7UyoVAPGtTRSgKm9bXLz',
    :access_token_secret => 'f7tIIgWFDzrrSBu2RrgnVtRHMEwuUEeykZjJ5rCTkOCcp'
    }

    client = Twitter::REST::Client.new(config)
    
    if @value[0][0] == 1
        @orders_db.execute(
        'UPDATE orders SET orderStatus = 2 WHERE orderID = (?)',
        [@orderID])
        
        client.update!("@#{@twitterHandle[0][0]} Order number ##{@orderID} has been accepted. We will let you know when it is ready for collection!", :in_reply_to_status_id => @tweetID[0][0])
        
    elsif @value[0][0] == 2
        @orders_db.execute(
        'UPDATE orders SET orderStatus = 3 WHERE orderID = (?)',
        [@orderID])
        
        client.update!("@#{@twitterHandle[0][0]} Order number #{@orderID} is ready for collection. Thankyou for using The Pizza Shed, we hope you enjoy!", :in_reply_to_status_id => @tweetID[0][0])
        
    elsif @value[0][0] == 3
        @orders_db.execute(
        'UPDATE orders SET orderStatus = 4 WHERE orderID = (?)',
        [@orderID])
        
    end
   
    
    query = %{SELECT *
              FROM orders}
    @results = @orders_db.execute query 
    
    redirect '/orders'
end

post '/deleteOrder' do
    @orderID = params[:orderID].strip
    @optionalReply = params[:optionalReply].strip
    @userID = @orders_db.execute('SELECT userID FROM orders WHERE orderID = ?', [@orderID])
    @twitterHandle = @accounts_db.execute('SELECT twitterHandle FROM customer WHERE userID = ?', [@userID]) 
    @tweetID = @orders_db.execute('SELECT tweetID FROM orders WHERE orderID = ?', [@orderID])
    
    config = {
    :consumer_key => 'ynFt8TAqAKrEyNlqFghyHTv6D',
    :consumer_secret => 'uFsWYaUDALKc3ugrBrzteQG4P4jgZQoKPfYjddegzLoRfmZ5A2',
    :access_token => '833682097734815745-hY14gIao0fv7UyoVAPGtTRSgKm9bXLz',
    :access_token_secret => 'f7tIIgWFDzrrSBu2RrgnVtRHMEwuUEeykZjJ5rCTkOCcp'
    }

    client = Twitter::REST::Client.new(config)
    
    if @optionalReply.nil? || @optionalReply == ""
         client.update!("@#{@twitterHandle[0][0]} Your order has not been accepted.", :in_reply_to_status_id => @tweetID[0][0])
         @orders_db.execute(
        'DELETE FROM orders WHERE orderID = (?)',
        [@orderID])
    else
        client.update!("@#{@twitterHandle[0][0]} #{@optionalReply} - Your order has not been accepted.", :in_reply_to_status_id => @tweetID[0][0])
         @orders_db.execute(
        'DELETE FROM orders WHERE orderID = (?)',
        [@orderID])
    end
    
   
    
    query = %{SELECT *
              FROM orders}
    @results = @orders_db.execute query 
    
    redirect '/orders'
end