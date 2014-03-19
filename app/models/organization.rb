class Organization < Group

	def members
		self.contact_subjects(:direction => :sent, :type=> :user)
	end

	def as_scim_json(version,controller)
		{
			schemas: ["urn:scim:schemas:core:2.0:Group"],
			id: actor.id,
			displayName: CGI::escapeHTML(name),
			members: self.members.map{ |user|
				{
					value: user.actor.id,
					ref: controller.root_url + "v2/users/" + user.actor.id.to_s,
					display: CGI::escapeHTML(user.name)
				}
			},
			meta:{
				resourceType: "Organization",
				created: created_at,
				lastModified: updated_at,
				version: "1",
				location: controller.request.url
			}
		}
	end
	
end
