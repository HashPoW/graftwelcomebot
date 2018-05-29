require './lib/message_sender'
require './lib/main_request'

Dir['./models/*'].each {|file| require file unless File.directory?(file)} 

class ChatMode

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
	 	if message.reply_to_message
	  	manage_replies
	  elsif message.edit_date
	  	puts message.text		
	  elsif message.new_chat_members.any?
	  	manage_new_members	
	  elsif	message.text
  		manage_direct_messages
	  elsif message.document
	  	manage_documents
	  elsif message.photo.first
	  	manage_photo	
	  elsif message.location
	  	manage_location
	  elsif message.contact	
	  	manage_contacts
	  end
	rescue => e
		puts e.message
		puts e.backtrace
	end

end	
