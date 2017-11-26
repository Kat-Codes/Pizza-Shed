require 'erb'
require 'sinatra'
require 'sqlite3'
require './signUpController.rb'
require './addPizza.rb'
require './ordersPageController.rb'
require './site.rb'
require './sessionController.rb'
require './myAccount.rb'
require './deletePizza.rb'
require './accountManagerController.rb'



include ERB::Util
enable :sessions
set :session_secret, 'super secret'

before do
    @orders_db = SQLite3::Database.new 'database/orders.sqlite'
end

get '/order' do   
    
    query = %{SELECT *
              FROM orders}
    @ordersList = @orders_db.execute query
    
    
#    @order_twitterID = @orders_db.execute('SELECT userID FROM orders')
#    @order_tweet_text = @orders_db.execute('select orderTEXT FROM orders')
#    @orders_length = @order_twitterID.length
#
#    @question_twitterID = @orders_db.execute('SELECT userID FROM questions')
#    @question_tweet_text = @orders_db.execute('select questionTEXT FROM questions')
#    @question_length = @question_twitterID.length
    
#     puts "on orders above loop"
#     every_n_seconds(15) do
#         twitter_loop
#         redirect '/orders'
#         puts "loop"
#     end
    
    erb :orders
end
    