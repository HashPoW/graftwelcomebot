require 'active_record'
require 'geocoder'
require 'geocoder/railtie'

Geocoder::Railtie.insert

class User < ActiveRecord::Base
	attr_accessor :latitude, :longitude
  reverse_geocoded_by :latitude, :longitude
	after_validation :reverse_geocode
	belongs_to :chat

	def admin?
		[46279756,352214533,387853250].include?(self.uid)
	end

end
