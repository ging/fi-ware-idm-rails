class Organization < Group

	#TODO
	def as_scim_json(version,controller)
		{
			schemas: ["urn:scim:schemas:core:2.0:Group"],
			id: actor.id,
			displayName: CGI::escapeHTML(name),
			# members: list_users,
			meta:{
				resourceType: "Group",
				created: created_at,
				lastModified: updated_at,
				version: "1",
				location: controller.request.url
			}
		}
	end

	def list_users
		# users = []
		# self.users.each do |user|
		# 	users.push({
		# 		vale:user.id,
		# 		#correct?
		# 		"$ref": controller.request.url,
		# 		display: CGI::escapeHTML(name)
		# 	})
		# end
		# users
	end
	
end
