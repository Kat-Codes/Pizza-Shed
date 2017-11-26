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



include ERB::Util
enable :sessions
set :session_secret, 'super secret'
VALID_EMAIL_REGEX ||= /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/

before do
    @accounts_db = SQLite3::Database.new 'database/accounts.sqlite'
end


get '/signup' do
	@submitted = false
	erb :signup
end

post '/signup' do
	@submitted = true
      
	# sanitize values
	@firstname = params[:firstname].strip
	@lastname = params[:lastname].strip
	@twitterhandle = params[:twitterhandle].strip.downcase
    @username = params[:username].strip.downcase
    @password = params[:password].strip
	@email = params[:email].strip.downcase
	@addressline1 = params[:addressline1].strip.downcase
    @addressline2 = params[:addressline2].strip.downcase
    @postcode = params[:postcode].strip
    @city = params[:city].strip.downcase 
    
    #get userID
    @userID = @accounts_db.execute('SELECT MAX(userID) FROM users')[0][0] +1
    
    #define account type (0 is customer)
    @account_type = 0
       
    #check user if user has included an @ and if so delete it before adding it to the database later on
    if @twitterhandle.start_with? '@'
        @twitterhandle.slice!(0)
    end
    
    #validation 
	@firstname_ok = !@firstname.nil? && @firstname != "" && @firstname.length < 15 
	@lastname_ok = !@lastname.nil? && @lastname != ""	&& @firstname.length < 20
    @password_ok = !@password.nil?
    @username_unique = !@accounts_db.execute('SELECT 1 FROM users WHERE username = ?', [@username]).any?
    @username_ok = !@username.nil? && @username_unique
    @twitterhandle_ok = !@accounts_db.execute('SELECT 1 FROM customer WHERE twitterhandle = ?', [@twitterhandle]).any?
    @email_unique = !@accounts_db.execute('SELECT 1 FROM users WHERE email = ?', [@email]).any?
    @email_ok = !@email.nil? && @email =~ VALID_EMAIL_REGEX && @email_unique
    @addressline1_ok = !@addressline1.nil?
    @postcode_ok = !@postcode.nil?
	@all_ok = @firstname_ok && @lastname_ok && @email_ok && @password_ok && @username_ok && @addressline1_ok && @postcode_ok && @twitterhandle_ok
  

	# add data to the database
    if @all_ok  
     #   id= @db.get_first_value 'SELECT MAX(id)+1 FROM customers';     
        @accounts_db.execute(
            'INSERT INTO users VALUES(?,?,?,?,?,?,?)',
            [@userID, @username, @password, @firstname, @lastname, @account_type, @email])
        @accounts_db.execute(
         'INSERT INTO customer VALUES (?,?,?,?,?,?)',
         [@userID, @twitterhandle, @addressline1, @addressline2, @postcode, @city])
        
      erb :signedUp  
      erb :homepage
    end
    
	erb :signup
    
    
end