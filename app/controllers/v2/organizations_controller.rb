class V2::OrganizationsController < V2::BaseController
	before_filter :checkValidActor, :only => [:show,:update,:destroy]

	#SCIM 2.0: LIST Organizations => GET /v2/organizations/
	def index
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
		unless can? :read, @organization
			render json: SCIMUtils.error("Permission denied",401) and return
		end

		respond_to do |format|
			format.any { render json: @organization.as_scim_json(v=2,self) }
		end
	end

	#SCIM 2.0: CREATE Organization => POST /v2/organizations/
	def create
		# #Params example
		# {
		# 	"organization"=>
		# 	{"name"=>"Name of the organization",
		# 	"owners"=>"1,6,7",
		# 	"description"=>"description"
		# 	"author_id"=>1,
		# 	"user_author_id"=>1,
		# 	"owner_id"=>1}
		# 	}
		# }

		if params[:organization] and !params[:organization][:owners].blank?
			begin
				author = Actor.find(params[:organization][:owners].split(",").first.to_i)

				if author.subject_type != "User"
					render json: SCIMUtils.error("Invalid Owner Id",404) and return
				end

				params[:organization][:author_id] = author.id
				params[:organization][:user_author_id] = author.id
				params[:organization][:owner_id] = author.id
			rescue Exception => e
				render json: SCIMUtils.error(e.message,500) and return
			end
		end

		organization = Organization.new(params[:organization])
		organization.valid?

		if organization.errors.blank? and organization.save
			render json: organization.as_scim_json(v=2,self)
		else
			render json: SCIMUtils.error(organization.errors,404)
		end
	end

	#SCIM 2.0: Update Organization => PUT /v2/organizations/:actorId
	def update
		unless can? :update, @organization
			render json: SCIMUtils.error("Permission denied",401) and return
		end

		if params[:organization] and !params[:organization][:owners].blank?
			begin
				author = Actor.find(params[:organization][:owners].split(",").first.to_i)
				if author.subject_type == "User"
					params[:organization][:author_id] = author.id
					params[:organization][:user_author_id] = author.id
					params[:organization][:owner_id] = author.id
				end
			rescue Exception => e
				render json: SCIMUtils.error(e.message,500) and return
			end
		end

		@organization.assign_attributes(params[:organization])
		@organization.valid?

		if @organization.errors.blank? and @organization.save
			render json: @organization.as_scim_json(v=2,self)
		else
			render json: SCIMUtils.error(organization.errors,404)
		end
	end

	#SCIM 2.0: Destroy Organization => DELETE /v2/organizations/:actorId
	def destroy
		unless can? :destroy, @organization
			render json: SCIMUtils.error("Permission denied",401) and return
		end

		if @organization.destroy
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

		if actor.subject_type != "Group"
			render json: SCIMUtils.error("Invalid Id",404) and return
		end

		@organization = actor.group
	end

end