require 'twitter'
require 'sqlite3'
#require 'sinatra'



config = {
:consumer_key => 'ynFt8TAqAKrEyNlqFghyHTv6D',
:consumer_secret => 'uFsWYaUDALKc3ugrBrzteQG4P4jgZQoKPfYjddegzLoRfmZ5A2',
:access_token => '833682097734815745-hY14gIao0fv7UyoVAPGtTRSgKm9bXLz',
:access_token_secret => 'f7tIIgWFDzrrSBu2RrgnVtRHMEwuUEeykZjJ5rCTkOCcp'
}

$client = Twitter::REST::Client.new(config)
#before do
    $customer_database = SQLite3::Database.new 'database/accounts.sqlite'
    $orders_database = SQLite3::Database.new 'database/orders.sqlite'
#end


#getting most recent tweets to the company 
# tweets = client.mentions_timeline()
# most_recent = tweets.take(3)
# #getting all the favourited tweets from the company to use later on
# favourited_tweets = client.favorites('ThePizzaShed')
# puts "most_recent: #{most_recent}" 
# puts "favourited tweets: #{favourited_tweets}}" 
# puts "id: #{most_recent[1].id}"
# puts " -------------"

# favourited_tweets.each do |tweet|
#     puts "fav tweet: #{tweet.text}"
# end
# 
# 
# tweet 1 c=0       fav 1   
# tweet 2           fav 2
# tweet 3           fav 3
# 
# 


#a system that favourites a tweet once its been looked at/replied to, as to keep track of new orders/tweets.
def favourite_checker(client)
    most_recent = client.mentions_timeline().take(3)
    favourited_tweets = client.favorites('ThePizzaShed')
    puts "fav tweets = #{favourited_tweets.length}"
    new_tweets = Array.new
  
    most_recent.each do |tweet|
        #if no tweets have been favourited, then tweet must be new so push to new tweets array
        if (favourited_tweets.length == 0)
            client.favorite(tweet.id)
            reply_to = tweet.user.screen_name
            counter = 0
            new_tweets.push(tweet)
            puts "fav tweet = 0 and #{tweet.user.screen_name}'s tweet different and replied" 
            puts
        #run through list of all favourited tweets, if the most_recent tweet hasnt been favourited, it hasnt been replied to so push to new_tweets array
        else
            counter = 0
            favourited_tweets.each do |fav_tweet|   
                puts "Tweet #{tweet.id}: #{tweet.text}"
                puts "user =   #{tweet.user.screen_name}" 
                if  (fav_tweet.id != tweet.id)   
                    counter+=1   
                    puts "not same #{counter} times"
                    puts
                else
                    puts "tweet the same" 
                    counter = 0
                    break
                end
                if (counter == favourited_tweets.length)
                    client.favorite(tweet.id)
#                     reply_to = tweet.user.screen_name
#                   client.update("@#{reply_to} test", :in_reply_to_status_id => tweet.id)
                    counter = 0
                    new_tweets.push(tweet)
                    puts "#{reply_to}'s tweet different and replied"    
                    puts                                   
                end 
            end
        end 
    end  
    return new_tweets
end


#checks if the tweeter has an account with pizza shed
def new_favourite_handler(id_array, client)
    valid_tweets = Array.new
    id_array.each do |tweet|
        db_list = Array.new
        current_user = tweet.user.screen_name
        has_account = false
        query = 'SELECT twitterHandle FROM customer'
        db_list = $customer_database.execute "SELECT twitterHandle FROM customer"       
        db_list.each do |row|
            puts "row is #{row}"
            puts "current user is [\"#{current_user}\"]"
            if ("[\"#{current_user}\"]" == "#{row}")
                has_account = true
                valid_tweets.push(tweet)
                puts "#{current_user} has an account!"
                #break
            end
        end
        if (!has_account)          
            puts "User #{current_user} does not have an account with PizzaShed"
            client.update("@#{current_user} You do not seem to have an account with us. Please sign up at thepizzashed.com!", :in_reply_to_status_id => tweet.id)
        end
    end
    return valid_tweets
end

#checks if tweet is an order or a question and sends them to the appopriate database.
def tweet_analyser(tweet_array, client)
    tweet_array.each do |tweet| 
        if tweet.text.downcase.include? "#order"      
            orderID = $orders_database.execute('SELECT MAX(orderID)+1 FROM orders')[0][0]
            if (orderID == nil)
                orderID = 1
            end
            
            puts "order id is #{orderID}"
            userID = $customer_database.execute('SELECT DISTINCT userID FROM customer WHERE twitterHandle = ?', [tweet.user.screen_name])
            specialOffer = $customer_database.execute('SELECT specialOffer FROM customer WHERE twitterHandle = ?', [tweet.user.screen_name])[0][0]
            if (specialOffer == nil)
                specialOffer = ""
            end
            puts "speical offer is #{specialOffer}"
            $orders_database.execute('INSERT INTO orders VALUES (?, ?, ?, ?, ?, ?)' , [orderID, tweet.id, userID, tweet.text, 1, specialOffer])
            client.update("@#{tweet.user.screen_name} Your order number ##{orderID} has been recieved and is being checked!", :in_reply_to_status_id => tweet.id)
            puts "order"
        elsif tweet.text.downcase.include? "#askpizzashed"
            questionID = $orders_database.execute('SELECT MAX(questionID)+1 FROM questions')[0][0]
            if (questionID == nil)
                questionID = 1
            end
            userID = $customer_database.execute('SELECT DISTINCT userID FROM customer WHERE twitterHandle = ?', [tweet.user.screen_name])         
            $orders_database.execute('INSERT INTO questions VALUES (?, ?, ?, ?, ?)' , [questionID, tweet.id, userID, tweet.text, 1])
            client.update("@#{tweet.user.screen_name} Your question has been recieved!", :in_reply_to_status_id => tweet.id)
            puts "question"
        elsif (tweet.text.downcase.include? "#cancel") | (tweet.text.downcase.include? "#update")
            puts "Change to order"
        else
            client.update("@#{tweet.user.screen_name} We didn't see a hashtag in your tweet. Put #order to order a tweet and #askpizzashed for any questions!", :in_reply_to_status_id => tweet.id)
        end    
        
        orderIDList = $orders_database.execute('SELECT orderID FROM orders') 
        orderIDList.each do |orderID|
            if (tweet.text.downcase.include? "##{orderID[0]}") & (tweet.text.downcase.include? "#cancel")
                userID1 = $orders_database.execute('SELECT userID FROM orders WHERE orderID = ?', [orderID[0]])
                userID2 = $customer_database.execute('SELECT userID FROM customer WHERE twitterHandle = ?', [tweet.user.screen_name])
                orderStatus = $orders_database.execute('SELECT orderStatus FROM orders WHERE orderID = ?', [orderID[0]])
                puts orderStatus[0][0]
                if (userID1 == userID2) & (orderStatus[0][0] < 3)
                    tweetID = $orders_database.execute('SELECT tweetID FROM orders WHERE orderID = ?', [orderID[0]])
                    $orders_database.execute('DELETE FROM orders WHERE orderID = ?', [orderID[0]])
                    client.update("@#{tweet.user.screen_name} Your order has been cancelled. Thankyou for using The Pizza Shed.", :in_reply_to_status_id => tweetID[0][0])
                elsif (userID == userID2) & (orderStatus[0][0] > 2)
                    client.update("@#{tweet.user.screen_name} Sorry, it is too late to cancel your order.", :in_reply_to_status_id => tweet.id)
                else
                    client.update("@#{tweet.user.screen_name} Sorry, this order number does not match this twitter account.", :in_reply_to_status_id => tweet.id)
                end
            end
            
            if (tweet.text.downcase.include? "##{orderID[0]}") & (tweet.text.downcase.include? "#update")
                userID1 = $orders_database.execute('SELECT userID FROM orders WHERE orderID = ?', [orderID[0]])
                userID2 = $customer_database.execute('SELECT userID FROM customer WHERE twitterHandle = ?', [tweet.user.screen_name])
                orderStatus = $orders_database.execute('SELECT orderStatus FROM orders WHERE orderID = ?', [orderID[0]])
                puts orderStatus[0][0]
                if (userID1 == userID2) & (orderStatus[0][0] < 3)
                    tweetID = $orders_database.execute('SELECT tweetID FROM orders WHERE orderID = ?', [orderID[0]])
                    orderDesc = $orders_database.execute('SELECT orderDesc FROM orders WHERE orderID = ?', [orderID[0]])
                    orderDescUpdate = orderDesc[0][0] + " - UPDATE - " + tweet.text 
                    $orders_database.execute('UPDATE orders SET orderDesc = ? WHERE orderID = ?', [orderDescUpdate, orderID[0]])
                    client.update("@#{tweet.user.screen_name} Order number ##{orderID[0]} has been updated. Thankyou for using The Pizza Shed.", :in_reply_to_status_id => tweetID[0][0])
                elsif (userID == userID2) & (orderStatus[0][0] > 2)
                    client.update("@#{tweet.user.screen_name} Sorry, it is too late to update your order.", :in_reply_to_status_id => tweet.id)
                else
                    client.update("@#{tweet.user.screen_name} Sorry, this order number does not match this twitter account.", :in_reply_to_status_id => tweet.id)
                end
            end
        end
    end        
end

def twitter_loop (client)
    
    time = Time.new
    new_tweets = favourite_checker(client)
    if (new_tweets.any?)
        valid_tweets = new_favourite_handler(new_tweets, client)
        tweet_analyser(valid_tweets, client)
    end
end

def every_n_seconds(n)
    loop do
        before = Time.now
        yield
        interval = n-(Time.now-before)
        sleep(interval) if interval > 0
    end
end

def special_offers(tweet_sent)
   client.update(tweet_sent)
end

def comp_analyser(client, hashtag)
    most_recent = client.user_timeline().take(50)
    most_recent.each do |tweet| 
        puts "#{tweet.text}"
        if (tweet.text.include? "#{hashtag}")
            compID = tweet.id
            retweets = client.retweeters_of(compID, options = {})
            if retweets.any?
                random_num = rand(retweets.length)
                chosen_user = retweets[random_num]
                puts "it is #{chosen_user.screen_name}"
                client.update("@#{chosen_user.screen_name} you won the #freePizza competition! #freePizza on your next order to redeem it!!")
                $customer_database.execute("UPDATE customer SET specialOffer = ? WHERE twitterHandle = ?", [hashtag, chosen_user.screen_name])
                client.destroy_tweet compID
                break
            end
        end
    end
   
end

def pickWinner(compID)
    most_recent = client.mentions_timeline()
end

#comp_analyser($client, "#freePizza")
   

#main
# password = "password"
# username = "lawrence1"
# userID = $customer_database.execute('SELECT userID FROM users WHERE userName = ?', [username])       
#     # sanitize values
    
#     userID = $customer_database.execute('SELECT userID FROM users WHERE userName = ?', [username])
#     puts "userid = #{userID}"
#     password_correct = $customer_database.execute('SELECT password FROM users WHERE userName = ?', [password])
#     puts "password = #{password}"
#     if (!userID.any? || password_correct.to_s.empty?) 
#         puts "wrong"
#     else
#         account_type = $customer_database.execute('SELECT accountType FROM users WHERE userName = ?', [username])[0][0]
#         puts "acc type = #{account_type}"
#         if (@account_type == 0)
#             puts"customer"
#         elsif (account_type == 1)
#            puts "admin"
#         end
#     end

# every_n_seconds(100) do
#     new_tweets = favourite_checker(client)
#     if (new_tweets.any?)
#         valid_tweets = new_favourite_handler(new_tweets, client)
#         tweet_analyser(valid_tweets, client)
#     end
# end
    
# new_tweets = favourite_checker(client)
# if (new_tweets.any?)
#     valid_tweets = new_favourite_handler(new_tweets, client)
#     tweet_analyser(valid_tweets, client)
# end
     

