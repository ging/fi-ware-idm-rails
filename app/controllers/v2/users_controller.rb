class V2::UsersController < V2::BaseController
	before_filter :checkValidActor, :only => [:show,:update,:destroy]

	#SCIM 2.0: LIST Users => GET /v2/users/
	def index
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
		unless can? :read, @user
			render json: SCIMUtils.error("Permission denied",401) and return
		end

		respond_to do |format|
			format.any { render json: @user.as_scim_json(v=2,self) }
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

		user = User.new(params[:user])
		user.valid?

		#Skip device validation...
		#This is needed to allow users to log in without validate its email. Prevent this error when a user try to logs in: You have to confirm your account before continuing.'
		user.skip_confirmation!

		respond_to do |format|
			format.any { 
				if user.errors.blank? and user.save
					render json: user.as_scim_json(v=2,self) 
				else
					render json: SCIMUtils.error(user.errors,404)
				end
			}
		end
	end

	#SCIM 2.0: Update User => PUT /v2/users/:actorId
	def update
		unless can? :update, @user
			render json: SCIMUtils.error("Permission denied",401) and return
		end

		if !params[:user].nil? and params[:user][:password].blank?
			params[:user].delete("password")
		end

		@user.assign_attributes(params[:user])
		@user.valid?

		if @user.errors.blank? and @user.save
			render json: @user.as_scim_json(v=2,self)
		else
			render json: SCIMUtils.error(@user.errors,404)
		end
	end

	#SCIM 2.0: Destroy User => DELETE /v2/users/:actorId
	def destroy
		unless can? :destroy, @user
			render json: SCIMUtils.error("Permission denied",401) and return
		end

		if @user.destroy
			render :nothing => true, :status => 204
		else
			render json: SCIMUtils.error("Internal server error",500)
		end
	end

	##########
	# Filters
	##########
	def checkValidActor
		actor = Actor.find(params[:id])

		if actor.subject_type != "User"
			render json: SCIMUtils.error("Invalid Id",404) and return
		end

		@user = actor.user
	end

end