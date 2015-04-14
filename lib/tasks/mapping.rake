# encoding: utf-8

namespace :migration do

	#How to use: bundle exec rake migration:migrate
	#In production: bundle exec rake migration:migrate RAILS_ENV=production
	task :migrate => :environment do |t, args|
		puts "Mapping data"

		#Users
		output["users"] = []
		users = User.all
		#Get only enabled users
		users = users.reject{|u| u.confirmed_at.nil?}
		users.each do |user|
			user_json = {
				"id" => user.id,
				"actor_id" => user.actor_id
			}
			output["users"].push(user_json)
		end

		File.open("migrationdata.json","w") do |f|
			f.write(output.to_json)
		end

		puts "Task finished. Output on migrationdata.json file."
	end

end