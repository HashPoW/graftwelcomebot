Dir['./lib/types/*'].each {|file| require file unless File.directory?(file)} 

module MainRequests

	include DirectMessage
	include Reply
	include Location
	include Contact
	include Photo
	include Document
	include NewMember

	def request(opts={text:'', parse_mode:"HTML"})
		
		if opts[:inline]
			opts[:answers]=agregate_inline_answers(opts[:answers]) 
		end
			
		command,content = if opts[:photo] 
			 ['send_photo', "photo: \"#{opts[:photo]}\""]
			else
				['send', "text: \"#{opts[:text]}\""]
		end	
		
		chat = opts[:chat] || message.chat || message.from
		send_code=%Q{ MessageSender.new(bot: bot, 
			chat: chat, 
			#{content}, 
			force_reply: opts[:force_reply], 
			answers: opts[:answers],
			inline: opts[:inline],
			parse_mode: opts[:parse_mode],
			contact_request: opts[:contact_request],
			location_request: opts[:location_request]).#{command} }
	
		eval send_code										
	rescue => e
		puts e.message
		puts __method__	  
	end

	def update(opts={text:''})
		if opts[:inline]
			opts[:answers]=agregate_inline_answers(opts[:answers]) 
		end
		answers = ReplyMarkupFormatter.new(opts[:answers]).get_inline_markup   if opts[:answers]
		bot.api.editMessageText(chat_id: opts[:message].chat.id , message_id: opts[:message].message_id, text: opts[:text], reply_markup: answers, parse_mode: 'HTML', disable_web_page_preview: true)
	rescue => e
		update_answers(opts)
		puts e.message
		puts __method__	  	
	end

	def update_answers(opts={text:''})
		if opts[:inline]
			opts[:answers]=agregate_inline_answers(opts[:answers]) 
		end
		answers = ReplyMarkupFormatter.new(opts[:answers]).get_inline_markup  
		bot.api.editMessageReplyMarkup(chat_id: opts[:message].chat.id , message_id: opts[:message].message_id, reply_markup: answers, parse_mode: 'HTML', disable_web_page_preview: true)
	rescue => e
		puts e.message
		puts __method__	  	
	end

	def not_valid_request(text="")
		request(text:"That’s not a valid command. #{text}")
	end

	def agregate_inline_answers(answers)
		answers.map do |answer|
			Telegram::Bot::Types::InlineKeyboardButton.new(answer)
		end	
	end

	def update_admins(chat,bot)
		
		admins_ids = bot.api.getChatAdministrators(chat_id:chat.id)['result']
                   .select{|a|!a['user']["is_bot"]}
                   .map{|a| a['user']['id']}
		
		chat.admins.delete_all

		User.where('uid IN (?)', admins_ids).each do |user|
			admin = Admin.new                   
			user.admins << admin
    	chat.admins << admin
    	admin.save
    end	
  rescue => e
		puts e.message
		puts __method__	    
	end


	def kick_user(chat, user, bot)
		bot.api.kickChatMember(chat_id:chat.id, user_id: user.uid)
    request(text:I18n.t('ban_message', appeal:user.appeal, admin:"@WolfGroups"), chat:message.chat,  parse_mode:'HTML')
  rescue => e
		puts e.message
		puts __method__	  
	end

	def delete_message(user, message, chat)
		if chat.mute
			bot.api.deleteMessage(chat_id:chat.id , message_id: message.message_id)
		end	
  rescue => e
		puts e.message
		puts __method__	  
	end


	def messages(type = 'request', message_type = "one_time")
		answers = if message_type == 'one_time'
						    Message.where(start_time:nil).map do |mes|
						    		text = if mes.text.size >32
						    			mes.text[0..32]+'...'
						    		else
						    			mes.text
						    		end		
						        {
						            text: text,
						            callback_data: "show_message_#{mes.id}"
						        }
						    end
						  else
						  	Message.where.not(start_time:nil).map do |mes|
						    		text = if mes.text.size >32
						    			mes.text[0..32]+'...'
						    		else
						    			mes.text
						    		end		
						        {
						            text: text,
						            callback_data: "show_message_#{mes.id}"
						        }
						    end
						  end  

		answers.unshift({text:'Delete all message', callback_data:"clear_messages#{message_type}"})
		answers << {text:'Back to types', callback_data:"choose_message_type"}	
		text = "Here's all existed messages"
		if type == 'request'
			request(text:text, inline:true, answers: answers, preview: true)
		else
			update(message:message.message, text: text, answers:answers) 
		end	
	end

end	
