require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ExternalIdpsController do

  # This should return the minimal set of attributes required to create a valid
  # ExternalIdp. As you add validations to ExternalIdp, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {  } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ExternalIdpsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all external_idps as @external_idps" do
      external_idp = ExternalIdp.create! valid_attributes
      get :index, {}, valid_session
      assigns(:external_idps).should eq([external_idp])
    end
  end

  describe "GET show" do
    it "assigns the requested external_idp as @external_idp" do
      external_idp = ExternalIdp.create! valid_attributes
      get :show, {:id => external_idp.to_param}, valid_session
      assigns(:external_idp).should eq(external_idp)
    end
  end

  describe "GET new" do
    it "assigns a new external_idp as @external_idp" do
      get :new, {}, valid_session
      assigns(:external_idp).should be_a_new(ExternalIdp)
    end
  end

  describe "GET edit" do
    it "assigns the requested external_idp as @external_idp" do
      external_idp = ExternalIdp.create! valid_attributes
      get :edit, {:id => external_idp.to_param}, valid_session
      assigns(:external_idp).should eq(external_idp)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ExternalIdp" do
        expect {
          post :create, {:external_idp => valid_attributes}, valid_session
        }.to change(ExternalIdp, :count).by(1)
      end

      it "assigns a newly created external_idp as @external_idp" do
        post :create, {:external_idp => valid_attributes}, valid_session
        assigns(:external_idp).should be_a(ExternalIdp)
        assigns(:external_idp).should be_persisted
      end

      it "redirects to the created external_idp" do
        post :create, {:external_idp => valid_attributes}, valid_session
        response.should redirect_to(ExternalIdp.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved external_idp as @external_idp" do
        # Trigger the behavior that occurs when invalid params are submitted
        ExternalIdp.any_instance.stub(:save).and_return(false)
        post :create, {:external_idp => {  }}, valid_session
        assigns(:external_idp).should be_a_new(ExternalIdp)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ExternalIdp.any_instance.stub(:save).and_return(false)
        post :create, {:external_idp => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested external_idp" do
        external_idp = ExternalIdp.create! valid_attributes
        # Assuming there are no other external_idps in the database, this
        # specifies that the ExternalIdp created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ExternalIdp.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => external_idp.to_param, :external_idp => { "these" => "params" }}, valid_session
      end

      it "assigns the requested external_idp as @external_idp" do
        external_idp = ExternalIdp.create! valid_attributes
        put :update, {:id => external_idp.to_param, :external_idp => valid_attributes}, valid_session
        assigns(:external_idp).should eq(external_idp)
      end

      it "redirects to the external_idp" do
        external_idp = ExternalIdp.create! valid_attributes
        put :update, {:id => external_idp.to_param, :external_idp => valid_attributes}, valid_session
        response.should redirect_to(external_idp)
      end
    end

    describe "with invalid params" do
      it "assigns the external_idp as @external_idp" do
        external_idp = ExternalIdp.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ExternalIdp.any_instance.stub(:save).and_return(false)
        put :update, {:id => external_idp.to_param, :external_idp => {  }}, valid_session
        assigns(:external_idp).should eq(external_idp)
      end

      it "re-renders the 'edit' template" do
        external_idp = ExternalIdp.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ExternalIdp.any_instance.stub(:save).and_return(false)
        put :update, {:id => external_idp.to_param, :external_idp => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested external_idp" do
      external_idp = ExternalIdp.create! valid_attributes
      expect {
        delete :destroy, {:id => external_idp.to_param}, valid_session
      }.to change(ExternalIdp, :count).by(-1)
    end

    it "redirects to the external_idps list" do
      external_idp = ExternalIdp.create! valid_attributes
      delete :destroy, {:id => external_idp.to_param}, valid_session
      response.should redirect_to(external_idps_url)
    end
  end

end
