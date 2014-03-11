class Organization < Group

	#TODO
	def as_scim_json(version,controller)
		{
			schemas: ["urn:scim:schemas:core:2.0:Group"],
			id: actor.id
		}
	end
	
end
