class V2::UsersController < ApplicationController

	def show
		actor = Actor.find(params[:id])

		if actor.subject_type != "User"
			render json: {
				error: ["Invalid Id"]
			}
			return;
		end

		user = actor.user

		unless can? :read, user
			render json: {
				error: ["Permission denied"]
			}
			return;
		end

		respond_to do |format|
			format.any { render json: user.as_scim_json(v=2,self) }
		end
	end

end