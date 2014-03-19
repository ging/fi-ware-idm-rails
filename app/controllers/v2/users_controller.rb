class V2::UsersController < ApplicationController
	require 'SCIMUtils'

	#SCIM 2.0: LIST Users => GET /v2/users/
	def index
		unless can? :manageSCIM, User
			render json: SCIMUtils.error("Permission denied")
			return;
		end

		users = [];
		User.all.each do |user|
			users.push(user.as_scim_json(v=2,self))
		end

		response = {
			schemas: ["urn:scim:schemas:core:2.0:ListResponse"],
			totalResults: users.length,
			Resources: users
		}

		respond_to do |format|
			format.any { render json: response }
		end
	end

	#SCIM 2.0: GET User => GET /v2/users/:actorId
	def show
		actor = Actor.find(params[:id])

		if actor.subject_type != "User"
			render json: SCIMUtils.error("Invalid Id")
			return;
		end

		user = actor.user

		unless can? :read, user
			render json: SCIMUtils.error("Permission denied")
			return;
		end

		respond_to do |format|
			format.any { render json: user.as_scim_json(v=2,self) }
		end
	end

end