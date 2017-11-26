require 'erb'
require 'sinatra'
require 'sqlite3'
require './signUpController.rb'
require './addPizza.rb'
require './site.rb'
require './sessionController.rb'
require './menu_controller.rb'
require './deletePizza.rb'
require './accountManagerController.rb'


include ERB::Util
enable :sessions
set :session_secret, 'super secret'

before do
    @accounts_db = SQLite3::Database.new 'database/accounts.sqlite'
end

get '/myAccount' do
    puts "la la"
    redirect '/' unless session[:sheffieldcustomer] || session[:londoncustomer]
    puts "no session" unless session[:sheffieldcustomer] || session[:londoncustomer] || session[:admin] 
    @submitted = false;
    
    @userID = @accounts_db.execute('SELECT userID FROM users WHERE username = ?', [session[:username]])[0]
    puts "user iD is #{@userID}"
    @results1 = @accounts_db.execute('SELECT username, firstname, surname, email FROM users WHERE userID = ?', [@userID])[0]
    @results2 = (@accounts_db.execute('SELECT twitterHandle, addressLine1, adressLine2, postcode, city FROM customer WHERE userID = ?', [@userID]))[0]
    @results = @results1 + @results2
    puts "results 0 is #{@results[0]} results 1 is #{@results[6]}"
    erb :myAccount
end

post '/changeDetails' do
	@submitted = true
    @userID = @accounts_db.execute('SELECT userID FROM users WHERE username = ?', [session[:username]])[0]
      
	# sanitize values
	@firstname = params[:firstname].strip
	@lastname = params[:lastname].strip
	@twitterhandle = params[:twitterhandle].strip
    @username = params[:username].strip
    @password = params[:password].strip
	@email = params[:email].strip
	@addressline1 = params[:addressline1].strip
    @addressline2 = params[:addressline2].strip
    @postcode = params[:postcode].strip   
    @city = params[:city].strip.downcase 
    
       
    #validation 
	@firstname_ok = !@firstname.nil? && @firstname != "" && @firstname.length < 15 
	@lastname_ok = !@lastname.nil? && @lastname != ""	&& @firstname.length < 20
    @email_ok = !@email.nil? && @email =~ VALID_EMAIL_REGEX  
    @city_ok = @city == "sheffield" || @city = "london"
	@all_ok = @firstname_ok && @lastname_ok && @email_ok && @city_ok
  

	# add data to the database
    if @all_ok     
        puts "all ok and updating"
        @accounts_db.execute(
         'UPDATE customer SET twitterHandle = ?, addressLine1 = ?, adressLine2 = ?, postcode = ?,
            city = ? WHERE userID = ?',
         [@twitterhandle, @addressline1, @addressline2, @postcode, @city, @userID])
        puts "updated, user id is #{@userID}"
        @accounts_db.execute(
            'UPDATE users SET username = ?, password = ?, firstname = ?, surname = ?,
            email = ? WHERE userID = ?',
            [@username, @password, @firstname, @lastname, @email, @userID])
      #Need to make and catch exception for if unique constraints failed so website doesnt just crash
      #erb :signedUp  
      redirect '/'
    end
    
	erb :myAccount
    
    
end