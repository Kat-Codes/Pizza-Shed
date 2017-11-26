require 'erb'
require 'sinatra'
require 'sqlite3'
require './addPizza.rb'
require './sessionController.rb'
require './site.rb'
require './myAccount.rb'
require './accountManagerController.rb'
require './deletePizza.rb'
require './menu_controller.rb'
require './twitter.rb'

include ERB::Util
enable :sessions
set :session_secret, 'super secret'

get '/sendTweet' do
	@submitted_tweet = false
	erb :tweet
end

get '/sendTweet2' do
	@submitted_tweet2 = false
	erb :tweet
end

get '/sendTweet3' do
	@submitted_tweet3 = false
	erb :tweet
end

get '/sendTweet4' do
	@submitted_tweet4 = false
	erb :tweet
end

post '/sendTweet' do 

    @submitted_tweet = true
    @checkedTweet = params[:inputTweet]
    
    @tweet_ok = !@checkedTweet.nil? && @checkedTweet!= "" && @checkedTweet.length < 140
    $client.update(@checkedTweet)
    
    if @tweet_ok
        erb:homepage
    end
    
    erb :tweet
  
end

post '/sendTweet2' do 
    @submitted_tweet3 = true;
    @checkedTweet = params[:inputTweet]
    
    $client.update(@checkedTweet)

    erb :tweet  
end

post '/pickTweet2' do
    comp_analyser($client, "#freePizza")
    
    erb :tweet
end

post '/sendTweet3' do 
    @submitted_tweet3 = true;
    @checkedTweet = params[:inputTweet]
    
    $client.update(@checkedTweet)

    erb :tweet 
end

post '/sendTweet4' do 
    @submitted_tweet4 = true;
    @checkedTweet = params[:inputTweet]
    
    $client.update(@checkedTweet)
    
    erb :tweet
  
end
