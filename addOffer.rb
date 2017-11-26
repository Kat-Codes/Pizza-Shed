require 'sqlite3'
require 'sinatra'
require 'erb'
require './signUpController.rb'
require './deletePizza.rb'
require './site.rb'
require './sessionController.rb'
require './myAccount.rb'
require './menu_controller.rb'
require './accountManagerController.rb'


include ERB::Util
enable :sessions
set :session_secret, 'super secret'



##Finds the database


before do
    @offer_db = SQLite3::Database.new 'database/offers.sqlite'
end


get '/addOffer' do
	@submitted_offer = false
	erb :addOffer       
end

post '/addOffer' do
	@submitted_offer = true
      
	##Values get sanitized
	@offerName = params[:offerName].strip
	@offerLocation = params[:offerLocation].strip
	@offerHash = params[:offerHash].strip
    @offerStart = params[:offerStart].strip
    @offerExpiry = params[:offerExpiry].strip
    @offerPrice = params[:offerPrice].strip
    @offerUrl = params[:offerUrl].strip
    
    ##Simple validation
	@offerName_ok = !@offerName.nil? && @offerName != ""
	@offerLocation_ok = !@offerLocation.nil? && @offerLocation != ""	
    @offerHash_ok = !@offerHash.nil? && @price != ""
    @offerStart_ok = !@offerStart.nil? && @offerStart != ""
    @offerExpiry_ok = !@offerExpiry.nil? && @offerExpiry != ""
    @offerPrice_ok = !@offerPrice.nil? && @offerPrice != ""
    @offerUrl_ok = !@offerUrl.nil? && @offerUrl != ""
	@all_ok = @offerName_ok && @offerLocation_ok &&  @offerHash_ok && @offerStart_ok && @offerEnd_ok && 
    @offerPrice_ok && @offerUrl_ok
    
	##Push to database
    if @all_ok              
        
        id = @offer_db.get_first_value 'SELECT MAX(id)+1 FROM specialOffers';
        
        @offer_db.execute(
         'INSERT INTO specialOffers VALUES (?,?,?,?,?,?,?,?)',
         [id, @offerName, @offerLocation, @offerStart, @offerEnd, @offerHash, @offerUrl, @offerPrice])  
        erb :homepage
      ##add a page to send to
    end
    
	erb :addOffer
end
