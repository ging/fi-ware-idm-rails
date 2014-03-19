class V2::BaseController < ApplicationController
	require 'SCIMUtils'

	#SCIM 2.0: Retrieve the Provider Configuration  => GET /v2/ServiceProviderConfigs
	def getConfig
		unless can? :manageSCIM, Organization
			render json: SCIMUtils.error("Permission denied",401)
			return;
		end

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

end