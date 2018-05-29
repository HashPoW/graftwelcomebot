module Location
	def manage_location
		latitude = message.location.latitude
		longitude = message.location.longitude
		timezone = Timezone.lookup(latitude,longitude)
		user.update_attributes( longitude: longitude, 
	  												latitude: latitude,
	  												timezone: timezone)
	end
end