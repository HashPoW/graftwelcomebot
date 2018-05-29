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
          text = "/price - will post the price of GRFT coin\n"+ 
                 "/supply - will post the circulating supply, total supply, and max supply of GRFT coin.\n"+
                 "/exchanges - will post the list of exchanges that GRFT is traded on\n"+
                 "/news - will post a link to the latest blog post from"
          request(text:text)      
        when /\A\/price/i
            request(text:"Current price: <b>#{Coinmarket.price} $</b>")
        when /\A\/supply/i  
            request(text:"Circulating Supply: <b>#{Coinmarket.supply} GRFT</b>")
        when /\A\/exchanges/i
            request(text:"Exchange markets:\n\n<b>#{Coinmarket.exchanges}</b>")
        when /\A\/news/i 
            page = Nokogiri::HTML(open('https://www.graft.network/blog/'))
            last_article_link = page.css('article a').first['href']
            text = "<b>Lastest news:</b>\n\n#{last_article_link}"
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