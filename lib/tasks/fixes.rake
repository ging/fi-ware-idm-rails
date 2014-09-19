# encoding: utf-8

namespace :fixes do
	#How to use: bundle exec rake fixes:fillDefaultRoleNames
	#In production: bundle exec rake fixes:fillDefaultRoleNames RAILS_ENV=production
	task :fillDefaultRoleNames => :environment do |t, args|
		puts "Filling default role names"

		providerRole = Relation.where("type='Relation::Manager'").first
		unless providerRole.nil?
			providerRole.update_column :name, "Provider"
		end

		purchaserRole = Relation.where("type='Relation::Purchaser'").first
		unless purchaserRole.nil?
			purchaserRole.update_column :name, "Purchaser"
		end
		
		puts "Task finished"
	end

end

 