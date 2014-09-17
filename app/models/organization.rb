class Organization < Group

	def members
		self.contact_subjects(:direction => :sent, :type=> :user)
	end

	def api_attributes(options={})
		attrs = Hash.new
		if options[:includeResources]
			attrs["members"] = self.members.map{|u| u.api_attributes({:includeResources => false})}
		end
		attrs
	end

	def to_json(params)
		self.attributes.merge({
			name: name,
			description: description
		}).to_json
	end

	def as_scim_json(version,controller)
		{
			schemas: ["urn:scim:schemas:core:2.0:Group"],
			id: actor.id,
			displayName: CGI::escapeHTML(name),
			description: CGI::escapeHTML(description),
			members: self.members.map{ |user|
				{
					value: user.actor.id,
					ref: controller.root_url + "v2/users/" + user.actor.id.to_s,
					display: CGI::escapeHTML(user.name)
				}
			},
			author: 
			{
				value: user_author.actor.id,
				ref: controller.root_url + "v2/users/" + user_author.actor.id.to_s,
				display: CGI::escapeHTML(user_author.name)
			},
			meta: {
				resourceType: "Organization",
				created: created_at,
				lastModified: updated_at,
				version: "1",
				location: controller.root_url + "v2/organizations/" + actor.id.to_s
			}
		}
	end
	
end
