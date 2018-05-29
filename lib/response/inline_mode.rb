require './lib/message_sender'

class InlineMode

	attr_reader :message
  attr_reader :bot
  attr_reader :user
  attr_reader :chat

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = options[:user]
    @user = options[:chat]
  end
	 
	def responce
	 	case message.query
	    when /start/i
	  end
 	end 

end	