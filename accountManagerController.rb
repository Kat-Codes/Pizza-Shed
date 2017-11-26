require 'erb'
require 'sinatra'
require 'sqlite3'
require './addPizza.rb'
require './sessionController.rb'
require './site.rb'
require './myAccount.rb'
require './signUpController.rb'
require './deletePizza.rb'
require './menu_controller.rb'



include ERB::Util
enable :sessions
set :session_secret, 'super secret'
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/

before do
    @accounts_db = SQLite3::Database.new 'database/accounts.sqlite'
end


get '/addAccount' do
	@submitted_acc = false
    @submitted_update = false
	erb :addAccount
end


#adding an account
post '/addAccount' do
	@submitted_acc = true

      
	# sanitize values
	@firstname = params[:firstname].strip
	@lastname = params[:lastname].strip
    @username = params[:username].strip
    @password = params[:password].strip
	@email = params[:email].strip
	@orderLondonPriviledge = params[:londonOP]
    @orderSheffieldPriviledge = params[:sheffieldOP]
    @accountsPriviledge = params[:accountsP]
    @menuPriviledge = params[:menuP]
    @marketingPriviledge = params[:marketingP]
    
    #get userID
    @userID = @accounts_db.execute('SELECT MAX(userID) FROM users')[0][0] +1
    
    puts" new user id = #{@userID}"
    
    # get account privilidges
    if (@orderLondonPriviledge == "yes")
        @orderLondonValue = 1
    else
        @orderLondonValue = 0
    end
    
    if (@orderSheffieldPriviledge == "yes")
        @orderSheffieldValue = 1
    else
        @orderSheffieldValue = 0
    end
    
    if (@accountsPriviledge == "yes")
        @accountsValue = 1
    else
        @accountsValue = 0
    end
    
    if (@menuPriviledge == "yes")
        @menuValue = 1
    else
        @menuValue = 0
    end
    
    if (@marketingPriviledge == "yes")
        @marketingValue = 1
    else
        @marketingValue = 0
    end
    
    puts "lon priv = #{@orderLondonValue}"
    #define account type (0 is customer)
    @account_type = 1
       
    #validation 
	@firstname_ok = !@firstname.nil? && @firstname != "" && @firstname.length < 15 
	@lastname_ok = !@lastname.nil? && @lastname != ""	&& @lastname.length < 20
    @email_unique = !@accounts_db.execute('SELECT 1 FROM users WHERE email = ?', [@email]).any?
    @username_unique = !@accounts_db.execute('SELECT 1 FROM users WHERE username = ?', [@username]).any?
    @email_ok = !@email.nil? && @email =~ VALID_EMAIL_REGEX && @email_unique && @email != ""
	@all_ok = @firstname_ok && @lastname_ok && @email_ok && @username_unique
  
    
	# add data to the database
    if @all_ok   
        @accounts_db.execute(
            'INSERT INTO users VALUES(?,?,?,?,?,?,?)',
            [@userID, @username, @password, @firstname, @lastname, @account_type, @email])
        @accounts_db.execute(
         'INSERT INTO admins VALUES (?,?,?,?,?,?)',
         [@userID, @orderLondonValue, @orderSheffieldValue, @accountsValue, @menuValue, @marketingValue])
        
      #Need to make and catch exception for if unique constraints failed so website doesnt just crash  
    end
    erb :accountManager   
end   
    
#updating an account
post '/changePriviledges' do
    @submitted_update = true
 

    # sanitize values
    @username = params[:username].strip
    @orderLondonPriviledge = params[:londonOP]
    @orderSheffieldPriviledge = params[:sheffieldOP]
    @accountsPriviledge = params[:accountsP]
    @menuPriviledge = params[:menuP]
    @marketingPriviledge = params[:marketingP]
    
    puts "lo #{@orderLondonPriviledge}sh#{@orderSheffieldPriviledge} ac#{@accountsPiviledge} me #{@menuPriviledge}ma#{@marketingPriviledge} ID#{@userID}"

   
    
    
    puts "username is #{@username}"
    #get userID
    @userID = @accounts_db.execute('SELECT userID FROM users WHERE username = ?', @username)[0]
    puts "user id #{@userID}"
    
    #check that username entered exists in admin table
    @userID_ok = @accounts_db.execute('SELECT 1 FROM admins WHERE userID = ?', [@userID]).any?
    puts "username ok? #{@userID_ok}"

    # get account privilidges
    if (@orderLondonPriviledge == "yes")
        @orderLondonValue = 1
    else
        @orderLondonValue = 0
    end

    if (@orderSheffieldPriviledge == "yes")
        @orderSheffieldValue = 1
    else
        @orderSheffieldValue = 0
    end

    if (@accountsPriviledge == "yes")
        @accountsValue = 1
    else
        @accountsValue = 0
    end

    if (@menuPriviledge == "yes")
        @menuValue = 1
    else
        @menuValue = 0
    end

    if (@marketingPriviledge == "yes")
        @marketingValue = 1
    else
        @marketingValue = 0
    end


    # add data to the database
   
    @accounts_db.execute(
        'UPDATE admins SET orderLondonPriviledge = ?, orderSheffieldPriviledge = ?, accountsPiviledge = ?,
            menuPriviledge = ?, marketingPriviledge = ? WHERE userID = ?',
        [@orderLondonValue, @orderSheffieldValue, @accountsValue, @menuValue, @marketingValue, @userID])
    
     puts "lo #{@orderLondonValue}sh#{@orderSheffieldValue} ac#{@accountsValue} me #{@menuValue}ma#{@marketingValue} ID#{@userID}"
    erb :accountManager   
end