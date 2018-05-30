module DirectMessage

	class Coinmarket

		API_ENDPOINT = "https://api.coinmarketcap.com/v2/ticker/2571/?convert=BTC"
		EXCH_ENDPOINT = "https://coinmarketcap.com/currencies/graft/#markets"
		
		def self.price
			[get_data["quotes"]["USD"]["price"],get_data["quotes"]["BTC"]["price"]]
		end

		def self.supply
			[
				get_data["circulating_supply"],
				get_data["total_supply"],
				get_data["max_supply"]
			]
		end

		def self.exchanges
			parse_website_for_exchanges
		end

		private

			def self.get_data
				response = Nokogiri::HTML(open(API_ENDPOINT))
				data = JSON.parse(response)
				data['data']
			end

			def self.parse_website_for_exchanges
				page = Nokogiri::HTML(open(EXCH_ENDPOINT))
				list = page.css("table#markets-table tbody a.link-secondary")
				list.map do |a|
					a.text
				end.join(",\n")
			end
	end

end