require 'yt'

class Youtube

	CHANNEL1 ='UCV-5A5mbnu64pPRUm1r_-5A'	
	CHANNEL2 ='UCoMSpYdhQDDhhRcyilyyqtw'	

	Yt.configure do |config|
	  config.api_key = 'AIzaSyCfWN9byZAhbz8vu_VSSIgBu3xuNkHNCm8'
	end

	def self.first_channel_title
		channel = Yt::Channel.new id: CHANNEL1
		channel.title.capitalize
	end

	def self.second_channel_title
		channel = Yt::Channel.new id: CHANNEL2
		channel.title.capitalize
	end

	def self.check_first_channel
		channel = Yt::Channel.new id: CHANNEL1
	  channel.videos.first.id
	end

	def self.check_second_channel
		channel = Yt::Channel.new id: CHANNEL2
		channel.videos.first.id
	end

end

