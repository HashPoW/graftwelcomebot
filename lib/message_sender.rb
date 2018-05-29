require './lib/reply_markup_formatter'
require './lib/app_configurator'

class MessageSender
  
  attr_reader :bot
  attr_reader :text
  attr_reader :photo
  attr_reader :caption
  attr_reader :document
  attr_reader :chat
  attr_reader :answers
  attr_reader :inline
  attr_reader :sticker
  attr_reader :logger
  attr_reader :force_reply
  attr_reader :preview
  attr_reader :contact_request
  attr_reader :location_request
  attr_reader :parse_mode

  def initialize(options)
    @bot = options[:bot ]
    @photo = options[:photo]
    @document = options[:document]
    @sticker = options[:stiker]
    @text = options[:text]
    @caption = options[:caption]
    @force_reply = options[:force_reply]
    @chat = options[:chat]
    @answers = options[:answers]
    @preview = options[:preview]
    @parse_mode = options[:parse_mode] || "HTML"
    @inline = options[:inline]
    @contact_request = options[:contact_request]
    @location_request = options[:location_request]
    @logger = AppConfigurator.new.get_logger
  end

  def send
    if reply_markup
      bot.api.send_message(chat_id: chat.id, text: text, parse_mode: parse_mode, reply_markup: reply_markup, disable_web_page_preview:false)
    else
      bot.api.send_message(chat_id: chat.id, text: text, parse_mode: parse_mode, disable_web_page_preview:false)
    end

    logger.debug "sending '#{text}' to #{chat.id}"
	rescue =>e
		puts e.message
		puts e.backtrace
	end


  def send_photo
    name=photo.split('/').last
    download_image(photo,"./pics/#{name}") if URI.extract(photo).first
    if photo&&File.exist?("./pics/#{name}")
      bot.api.send_photo(chat_id: chat.id, photo: Faraday::UploadIO.new("./pics/#{name}", 'image/jpeg'), caption: caption, reply_markup: reply_markup )
    elsif photo  
      bot.api.send_photo(chat_id: chat.id, photo: photo, caption: caption, reply_markup: reply_markup)
    end  
  end

  def send_document
    # document is path to file needed to send
    if File.exist?(document) 
      bot.api.send_document(chat_id: chat.id, document: Faraday::UploadIO.new(document) )
    end  
  end
    
  def send_sticker
    bot.api.send_sticker(chat_id: chat.id, sticker:sticker)
  end  


  private

  def download_image(url, dest) 
    file=''
    open(url) do |u| 
      file=File.open(dest, 'wb') { |f| f.write(u.read) } 
    end 
    file
  end 

  def reply_markup
    if answers&&inline
      ReplyMarkupFormatter.new(answers).get_inline_markup    
    elsif contact_request
      ReplyMarkupFormatter.new(answers).get_contact_request(contact_request)
    elsif location_request
      ReplyMarkupFormatter.new(answers).get_location_request(location_request) 
    elsif answers
      ReplyMarkupFormatter.new(answers).get_markup
    elsif force_reply
      ReplyMarkupFormatter.new(answers).get_force_reply
    end
  end

end
