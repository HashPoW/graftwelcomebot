class Website
	def self.check
		page = Nokogiri::HTML(open('https://www.graft.network/blog/'))
    last_article_link = page.css('article a').first['href']
	end
end