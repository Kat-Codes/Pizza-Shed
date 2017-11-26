require 'erb'
require 'sinatra'
require 'sqlite3'
require './signUpController.rb'
require './addPizza.rb'
require './site.rb'
require './myAccount.rb'
require './menu_controller.rb'
require './deletePizza.rb'
require './accountManagerController.rb'


include ERB::Util
enable :sessions
set :session_secret, 'super secret'


before do
    @accounts_db = SQLite3::Database.new 'database/accounts.sqlite'
end

get '/login' do
    redirect '/' unless !session[:sheffieldcustomer] && !session[:londoncustomer] && !session[:admin]
	@submitted_login = false
	erb :login
end

post '/login' do
    @submitted_login = true
    
    # sanitize values
    @username = params[:username].strip
    @password = params[:password].strip
    @userID = @accounts_db.execute('SELECT userID FROM users WHERE userName = ?', [@username])
    
    puts "asdf #{@userID}"
    
    if (@userID[0] !=  nil)
         @password_correct_db = @accounts_db.execute('SELECT password FROM users WHERE userName = ?', [@username])
         @password_correct = @password_correct_db[0][0]
    end
    
    
  
    if (@password == @password_correct) 
        #discern if user is admin or customer
        @account_type = @accounts_db.execute('SELECT accountType FROM users WHERE userName = ?', [@username])[0][0] 
        
        #if user is an admin
        if (@account_type == 1)
            session[:admin] = true
        
            #see which type of admin user is
            @sheff = @accounts_db.execute('SELECT orderSheffieldPriviledge FROM admins WHERE userID = ?', [@userID])[0][0]
            @london = @accounts_db.execute('SELECT orderLondonPriviledge FROM admins WHERE userID = ?', [@userID])[0][0]
            @accounts = @accounts_db.execute('SELECT accountsPiviledge FROM admins WHERE userID = ?', [@userID])[0][0]
            @menu = @accounts_db.execute('SELECT menuPriviledge FROM admins WHERE userID = ?', [@userID])[0][0]
            @marketing = @accounts_db.execute('SELECT marketingPriviledge FROM admins WHERE userID = ?', [@userID])[0][0]
            
            puts "sheff #{@sheff} lon #{@london} acc #{@accounts}  menu #{@menu} mark #{@marketing}"
            if (@london == 1)
                session[:londonAdmin] = true
                puts "london ad"
            end
            if (@sheff == 1)
                session[:sheffieldAdmin] = true
            end
            if (@accounts == 1)
                session[:accountsAdmin] = true
            end
            if (@menu == 1)
                session[:menuAdmin] = true
            end
            if (@marketing == 1)
                session[:marketingAdmin] = true
            end
            
     
            redirect '/admin'

        elsif (@account_type == 0)
            @city = @accounts_db.execute('SELECT city FROM customer WHERE userID = ?', [@userID])[0][0]
            if (@city.downcase == "sheffield")
                session[:sheffieldcustomer] = true
                session[:username] = @username
                puts "username session = #{session[:username]}"
                redirect '/sheffield'
            elsif (@city.downcase == "london")
                session[:londoncustomer] = true
                session[:username] = @username
                redirect '/london'
            end
        end
        
    end
    erb :login
end
	