require 'active_record'

class Chat < ActiveRecord::Base
	
	has_many :users, dependent: :destroy

end
