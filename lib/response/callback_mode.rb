require './lib/message_sender'
require './lib/main_request'
Dir['./models/*'].each {|file| require file unless File.directory?(file)} 

class CallbackMode

  include MainRequests
	
	attr_reader :message
  attr_reader :bot
  attr_reader :user
  attr_reader :chat

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = options[:user]
    @chat = options[:chat]
  end
	 
  def response
	  # case                  
	end 

    
end	
