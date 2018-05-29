module Contact
	def manage_contacts
		user.update_attributes( phone: message.contact.phone_number,
										 				fname: message.contact.first_name,
														lname: message.contact.last_name)
	end
end