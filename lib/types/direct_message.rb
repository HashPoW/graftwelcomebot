module DirectMessage

	def manage_direct_messages
		case message.text 
        when '/start'
          answer_with_greeting_message
        when '/stop'
          answer_with_farewell_message
        when /\A\/welcome_on/
            turn_on_welcome    
        when /\A\/welcome_off/    
            turn_off_welcome  
        when /\A\/help/i
          text = "/price - <i>will post the price of GRFT coin</i>\n"+ 
                 "/supply - <i>will post the circulating supply, total supply, and max supply of GRFT coin.</i>\n"+
                 "/exchanges - <i>will post the list of exchanges that GRFT is traded on</i>\n"+
                 "/news - <i>will post a link to the latest blog post from</i>"
          request(text:text)      
        when /\A\/price/i
            request(text:"Current price: \n\n<b>#{Coinmarket.price[0]} USD\n#{'%.12f' % Coinmarket.price[1]} BTC</b>")
        when /\A\/supply/i  
            request(text:"Circulating Supply: <b>#{Coinmarket.supply[0]} GRFT</b>\n"+
                         "Total Supply: <b>#{Coinmarket.supply[1]} GRFT</b>\n"+
                         "Max Supply: <b>#{Coinmarket.supply[2]} GRFT</b>\n")
        when /\A\/exchanges/i
            request(text:"Exchange markets:\n\n<b>#{Coinmarket.exchanges}</b>")
        when /\A\/news/i 
            text = "<b>Lastest news:</b>\n\n#{Website.check}"
            request(text:text)   
        end
	end

    def turn_on_welcome 
        return unless user.admin?
        @chat.update_attribute(:welcome_on, true)
        request(text:"Welcome messages on")
    end

    def turn_off_welcome 
        return unless user.admin?
        @chat.update_attribute(:welcome_on, false)
        request(text:"Welcome messages off")
    end

	def answer_with_greeting_message
	  text = I18n.t('greeting_message')

	  MessageSender.new(bot: bot, chat: message.from, text: text).send
	end

	def answer_with_farewell_message
	  text = I18n.t('farewell_message')

	  MessageSender.new(bot: bot, chat: message.from, text: text).send
	end

end	
