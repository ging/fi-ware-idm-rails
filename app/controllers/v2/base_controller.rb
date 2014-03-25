# You can use the template http://localhost:3000/v2/testing to test the SCIM API

class V2::BaseController < ApplicationController
	require 'SCIMUtils'
	before_filter :authenticate_user!
	before_filter :authorizeSCIM, :except => [:testing,:getConfig]
	before_filter :authorizeSCIMWatcher, :only => [:getConfig]

	def authorizeSCIM
		unless can? :manageSCIM, User
			render json: SCIMUtils.error("Permission denied",401) and return
		end
	end

	def authorizeSCIMWatcher
		unless ((can? :manageSCIM, User)or(can? :showSCIM, User))
			render json: SCIMUtils.error("Permission denied",401) and return
		end
	end

	#SCIM 2.0: Retrieve the Provider Configuration  => GET /v2/ServiceProviderConfigs
	def getConfig
		totalUsers = User.count;
		totalOrganizations = Organization.count;
		totalResources = totalUsers + totalOrganizations

		response = {
			schemas: ["urn:scim:schemas:core:2.0:ServiceProviderConfig"],
			documentationUrl: "https://tools.ietf.org/html/draft-ietf-scim-core-schema-02",
			totalUsers: totalUsers.to_s,
			totalOrganizations: totalOrganizations.to_s,
			totalResources: totalResources.to_s
		}

		respond_to do |format|
			format.any { render json: response }
		end
	end

	#Testing the SCIM 2.0 API  => /v2/testing
	def testing
		render :layout => false
	end

end