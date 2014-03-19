class V2::OrganizationsController < ApplicationController
	require 'SCIMUtils'

	#SCIM 2.0: LIST Organizations => GET /v2/organizations/
	def index
		unless can? :manageSCIM, Organization
			render json: SCIMUtils.error("Permission denied")
			return;
		end

		organizations = [];
		Organization.all.each do |organization|
			organizations.push(organization.as_scim_json(v=2,self))
		end

		response = {
			schemas: ["urn:scim:schemas:core:2.0:ListResponse"],
			totalResults: organizations.length,
			Resources: organizations
		}

		respond_to do |format|
			format.any { render json: response }
		end
	end

	#SCIM 2.0: GET Organization => GET /v2/organization/:actorId
	def show
		actor = Actor.find(params[:id])

		if actor.subject_type != "Group"
			render json: SCIMUtils.error("Invalid Id")
			return;
		end

		organization = actor.group

		unless can? :read, organization
			render json: SCIMUtils.error("Permission denied")
			return;
		end

		respond_to do |format|
			format.any { render json: organization.as_scim_json(v=2,self) }
		end
	end

end