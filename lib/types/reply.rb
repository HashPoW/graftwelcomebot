module Reply
	def manage_replies
		case message.text
		when /\/welcome/
      set_welcome_message	
		end	
					
		case message.reply_to_message.text
		when  /Reply text/
			request(text:"Reply to request",  preview: true)
		end	 
	end

	def set_welcome_message
    return unless user.admin?
    chat.welcome_message = message.reply_to_message.text.gsub('"', "'")
    chat.save
    request(text:I18n.t('welcome_message_saved', message:chat.welcome_message))
  end
end
