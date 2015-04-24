# encoding: utf-8

namespace :migration do

	#How to use: bundle exec rake migration:migrate
	#In production: bundle exec rake migration:migrate RAILS_ENV=production
	task :migrate => :environment do |t, args|
		puts "Migrating data"

		output = {}

		#Organizations
		output["organizations"] = []
		organizations = Organization.all
		organizations.each do |organization|
			organization_json = {
				"id" => organization.actor_id,
				"name" => organization.name,
				"description" => organization.description,
				"city" => organization.profile.city,
				"email" => organization.email,
				"website" => organization.profile.website,
				"avatar" => organization.logo,
				"members" => organization.members.map{|u| u.actor_id},
				"owners" => organization.members.select{|m| organization.contact_to(m.actor).relations.include? Relation::Owner.instance}.map{|m| m.actor.id}
			}
			unless organization.user_author.nil? or organization.user_author.actor.nil?
                organization_json["owner"] = organization.user_author.actor.id
            end
			output["organizations"].push(organization_json)
		end

		#Users
		output["users"] = []
		users = User.all
		#Get only enabled users
		users = users.reject{|u| u.confirmed_at.nil?}
		users.each do |user|
			user_json = {
				"nick" => user.slug,
				"id" => user.actor_id,
				"name" => user.name,
				"email" => user.email,
				"website" => user.profile.website,
				"aboutme" => user.profile.description,
				"city" => user.profile.city,
				"enabled" => true,
				"avatar" => user.logo
			}
			output["users"].push(user_json)
		end

		#Applications
		output["applications"] = []
		applications = Application.all
		applications.each do |app|
			application_json = {
				"id" => app.actor_id,
				"name" => app.name,
				"description" => app.description,
				"url" => app.url,
				"callback_url" => app.callback_url,
				"oauth2_secret" => app.secret,
				"oauth2_client_id" => app.id,
				"avatar" => app.logo
			}
			unless app.user_author.nil? or app.user_author.actor.nil?
                application_json["owner"] = app.user_author.actor.id
            end
			output["applications"].push(application_json)
		end

		#Application Roles
		output["roles"] = []
		internalRoles = Relation.where("type IN (?)", ["Relation::Manager","Relation::Purchaser"])
		customAppRoles = Relation.where("sender_type='Site' and type IN (?)", ["Relation::Custom"])
		customAppRoles = customAppRoles.reject{|r| r.actor.nil? or r.actor.subject_type!="Site"}
 		roles = (internalRoles + customAppRoles)
		roles.each do |role|
			is_internal = !(role.type === "Relation::Custom")
			role_json = {
				"id" => role.id,
				"name" => role.name,
				"is_internal" => is_internal
			}
			unless is_internal
				role_json["application_id"] = role.actor.id
			end
			output["roles"].push(role_json)
		end

		#Permission
		output["permissions"] = []
		internalPermissions = Permission.all.select{|p| !(p.relations & internalRoles).empty?}
		customPermissions = Permission::Custom.all
		customPermissions = customPermissions.reject{|p| p.actor.nil? or p.actor.subject_type!="Site"}
		permissions = (internalPermissions + customPermissions ).uniq
		permissions.each do |permission|

			is_internal = !(permission.type === "Permission::Custom")
			if is_internal
				permission_name = permission.object.nil? ? permission.action : (permission.action + " " + permission.object)
			else
				permission_name = permission.name
			end

			permission_json = {
				"id" => permission.id,
				"name" => permission_name,
				"is_internal" => is_internal
			}
			unless is_internal
				permission_json["application_id"] = permission.actor.id
			end
			output["permissions"].push(permission_json)
		end

		#RolePermission
		output["rpermissions"] = []
		# rolePermissions = RelationPermission.all (this query only returns the enabled permissions. Also it returns permissions not related to applications.)
		roles.each do |role|
			rpermissions = role.available_permissions
			rpermissions.each do |permission|
				rpermission_json = {
					"role_id" => role.id,
					"permission_id" => permission.id,
					"enabled" => (role.permissions.include? (permission))
				}
				output["rpermissions"].push(rpermission_json)
			end
		end

		#RoleUser
		output["rusers"] = []
		applications.each do |app|
			app.actors.select{|actor| ["Group","User"].include? actor.subject_type}.each do |actor|
				#Groups and Users
				if app.grants_roles?(actor)

					app.contact_to(actor).relation_ids.map{ |rid| Relation.find(rid) }.reject{ |role| !roles.include? role }.each do |role|
						ruser_json = {
							"role_id" => role.id,
							"application_id" => app.actor.id
						}

						if actor.subject_type == "Group"
							ruser_json["organization_id"] = actor.id
						elsif actor.subject_type == "User"
							ruser_json["user_id"] = actor.id
						end

						output["rusers"].push(ruser_json)
					end
				
					#Specific roles of the members when they act as this group
					if actor.subject_type == "Group"
						actor.group.members.each do |user|
							actor.contact_to(user.actor).relation_ids.map{ |rid| Relation.find(rid) }.select{|r| r.actor_id == app.actor_id}.reject{ |role| !roles.include? role }.each do |role|
								ruser_json = {
									"role_id" => role.id,
									"user_id" => user.actor.id,
									"organization_id" => actor.id,
									"application_id" => app.actor.id
								}
								output["rusers"].push(ruser_json)
							end
						end
					end

				end
			end
		end

		#Administrators
		output["administrators"] = []
		administrators = Site.current.sent_contacts.select{|c| c.relations.include? Relation::LocalAdmin.instance}.map{|c| Actor.find(c.receiver_id)}
		administrators.each do |actor|
			admin_json = {
				"user_id" => actor.id
			}
			output["administrators"].push(admin_json)
		end


		File.open("migrationdata.json","w") do |f|
			f.write(output.to_json)
		end

		puts "Task finished. Output on migrationdata.json file."
	end

end