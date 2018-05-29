require './models/user'
require './lib/message_sender'
require './lib/response/callback_mode.rb'
require './lib/response/inline_mode.rb'
require './lib/response/chat_mode.rb'

class MessageResponder
  
  attr_reader :message
  attr_reader :bot
  attr_reader :user
  attr_reader :chat

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]

    if message.class == Telegram::Bot::Types::CallbackQuery 
      @chat = Chat.find_or_create_by(id: message.message.chat.id)
      @user = @chat.users.find_or_create_by(uid: message.message.from.id)
    elsif message.from
      @chat = Chat.find_or_create_by(id: message.chat.id)
      @chat.update_attribute(:title, message.chat.title)
      @user = @chat.users.find_or_create_by(uid: message.from.id)
      
      unless user.fname && message.from.first_name
        @user.update_attribute(:fname, message.from.first_name) 
      end
        
      unless user.lname && message.from.last_name
        @user.update_attribute(:lname, message.from.last_name) 
      end
        
      if !user.username && message.from.username
        @user.update_attribute(:username, "@#{message.from.username}") 
      end   
      
    else  
      @chat = Chat.find_or_create_by(id: message.chat.id)
      @chat.update_attribute(:title, message.chat.title)
      @user = @chat.users.find_or_create_by(uid: message.chat.id)
    end
  end

  def respond
    case message
      when Telegram::Bot::Types::InlineQuery
        # Here you can handle your inline commands
        InlineMode.new(message: message ,bot: bot, user: user, chat: chat).response
      when Telegram::Bot::Types::CallbackQuery
        # Here you can handle your callbacks from inline buttons
        CallbackMode.new(message: message ,bot: bot, user: user, chat: chat).response
      when Telegram::Bot::Types::Message   
        # Here you can handle your requests from chat
        ChatMode.new(message: message ,bot: bot, user: user, chat: chat).response
    end    
	rescue =>e
		puts e.message
		puts e.backtrace
		puts __method__
  end
end
