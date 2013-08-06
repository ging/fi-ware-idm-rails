require 'spec_helper'

describe UsersController do
  render_views

  describe "when authenticated" do
    before do
      @user = Factory(:user)
      @user.confirm!

      sign_in @user
    end

    it "should get user info" do
      get :current, format: :json

      binding.pry
      response.should be_success
    end
  end
end
