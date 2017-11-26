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

get '/questions' do
    
    twitter_loop($client)
    @sheffieldID = @accounts_db.execute('SELECT userID FROM customer WHERE city = "sheffield"')
    @sheffieldQuestions = []
    @sheffieldID.each do |this|
        @sheffieldQuestions += @orders_db.execute('SELECT * FROM questions WHERE userID =?', [this[0]]) 
    end
    
    @londonID = @accounts_db.execute('SELECT userID FROM customer WHERE city = "london"')
    @londonQuestions = []
    @londonID.each do |this|
        @londonQuestions += @orders_db.execute('SELECT * FROM questions WHERE userID =?', [this[0]]) 
    end
    
    
    erb :questions
end

post '/answerQuestion' do 
    @questionID = params[:questionID].strip
    @answer = params[:answer].strip
    @userID = @orders_db.execute('SELECT userID FROM questions WHERE questionID = ?', [@questionID])
    @twitterHandle = @accounts_db.execute('SELECT twitterHandle FROM customer WHERE userID = ?', [@userID])
    @tweetID = @orders_db.execute('SELECT tweetID FROM questions WHERE questionID = ?', [@questionID])
    @questionStatus = @orders_db.execute('UPDATE questions SET questionStatus = 2 WHERE questionID = ?', [@questionID])
    config = {
    :consumer_key => 'ynFt8TAqAKrEyNlqFghyHTv6D',
    :consumer_secret => 'uFsWYaUDALKc3ugrBrzteQG4P4jgZQoKPfYjddegzLoRfmZ5A2',
    :access_token => '833682097734815745-hY14gIao0fv7UyoVAPGtTRSgKm9bXLz',
    :access_token_secret => 'f7tIIgWFDzrrSBu2RrgnVtRHMEwuUEeykZjJ5rCTkOCcp'
    }

    client = Twitter::REST::Client.new(config)
    
    client.update("@#{@twitterHandle[0][0]} #{@answer}", :in_reply_to_status_id => @tweetID[0][0])
    
    query = %{SELECT *
              FROM questions}
    @results = @orders_db.execute query 
    
    redirect '/questions'
end

post '/deleteQuestion' do
    questionID = params[:questionID].strip
    
    @orders_db.execute(
        'DELETE FROM questions WHERE questionID = 1')
    
    query = %{SELECT *
              FROM questions}
    @results = @orders_db.execute query 
    
    redirect '/questions'
end
