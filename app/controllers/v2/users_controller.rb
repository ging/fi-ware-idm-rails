# You can use the template http://localhost:3000/scimapi to test the SCIM API

class V2::UsersController < ApplicationController
	require 'SCIMUtils'

	#SCIM 2.0: LIST Users => GET /v2/users/
	def index
		unless can? :manageSCIM, User
			render json: SCIMUtils.error("Permission denied",401)
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
			render json: SCIMUtils.error("Invalid Id",404)
			return;
		end

		user = actor.user

		unless can? :read, user
			render json: SCIMUtils.error("Permission denied",401)
			return;
		end

		respond_to do |format|
			format.any { render json: user.as_scim_json(v=2,self) }
		end
	end

	#SCIM 2.0: CREATE User => POST /v2/users/
	def create
		# #Params example
		# {
		#  "user"=>
		# {"name"=>"Demo",
		#  "email"=>"demo@social-stream.dit.upm.es",
		#  "password"=>"demonstration",
		#  "password_confirmation"=>"demonstration"},
		# }

		unless can? :manageSCIM, User
			render json: SCIMUtils.error("Permission denied",401)
			return;
		end

		user = User.new(params[:user])
		user.valid?

		#Skip device validation...
		#This is needed to allow users to log in without validate its email. Prevent this error when a user try to logs in: You have to confirm your account before continuing.'
		user.skip_confirmation!

		respond_to do |format|
			format.any { 
				if user.errors.blank? and user.save
					render json: user 
				else
					render json: user.errors, status: :unprocessable_entity
				end
			}
		end
	end

	#SCIM 2.0: Update User => PUT /v2/users/:actorId
	def update
		actor = Actor.find(params[:id])

		if actor.subject_type != "User"
			render json: SCIMUtils.error("Invalid Id",404)
			return;
		end

		user = actor.user

		unless can? :update, user
			render json: SCIMUtils.error("Permission denied",401)
			return;
		end

		if !params[:user].nil? and params[:user][:password].blank?
			params[:user].delete("password")
		end

		user.assign_attributes(params[:user])
		user.valid?

		if user.errors.blank? and user.save
			render json: user
		else
			render json: user.errors, status: :unprocessable_entity
		end
	end

end