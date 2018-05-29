module NewMember

	def manage_new_members
        delete_previous_one
        message.new_chat_members.each do |member|
            # return manage_new_bot(member) if member.is_bot 
            proceed_user(member) 
        end
    rescue => e
        puts e.message
        puts e.backtrace
    end

    def delete_previous_one
        bot.api.deleteMessage(chat_id:message.chat.id, message_id:message.message_id)
    rescue => e
        puts e.message
        puts e.backtrace    
    end
    # def manage_new_bot(member)
    # 	bot_user = User.find_or_create_by(uid: member.id)
    # 	bot_user.chats << @chat unless bot_user.chats.include?(@chat)
    # 	return if AllowedBot.exists?(username:member.username.downcase)
    #     text = I18n.t('bot_not_allowed')
    # 	kick_user(chat, bot_user, bot, text)
    # end

    def proceed_user(member)
        return unless chat.welcome_on
		username =
					if member.username
						"@#{member.username}"
					elsif member.first_name
						"#{member.first_name}"
					elsif member.last_name
						"#{member.last_name}"
					else
						""
					end
        chatname = @chat.title
        # kb = [  
        #   Telegram::Bot::Types::InlineKeyboardButton.new(text: 'FAQ', url: 'https://wolfglobal.org/faq'),
        #   Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Rules', url: 'https://t.me/WolfGlobal101')
        # ]
        # markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
        welcome_message = @chat.welcome_message
                                .gsub(/@username/,username)
                                .gsub(/@chatname/,chatname)
        message_details = bot.api.sendMessage(text: welcome_message, 
                                              chat_id: @chat.id, 
                                              parse_mode: 'HTML')
                                              # reply_markup: markup)
    rescue =>e 
        puts e.message   
        puts e.backtrace
        puts __method__   
    end

	def delete_(message)
		bot.api.deleteMessage(chat_id:message['chat.id'], message_id:message['message_id'])
	rescue =>e
	end
end
