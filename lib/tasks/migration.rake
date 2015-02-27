# encoding: utf-8

namespace :migration do

	#How to use: bundle exec rake migration:migrate
	#In production: bundle exec rake migration:migrate RAILS_ENV=production
	task :migrate => :environment do |t, args|
		puts "Migrating data"

		output = {}

		#Organizations
		output["organizations"] = []
		organizations = [Organization.first]
		organizations.each do |organization|
			organization_json = {
				"id" => organization.id
			}
			output["organizations"].push(organization_json)
		end

		#Role

		File.open("migrationdata.json","w") do |f|
			f.write(output.to_json)
		end

		puts "Task finished"
	end

end