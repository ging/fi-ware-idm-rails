require 'spec_helper'

describe PurchasesController do
  render_views

  before :all do
    @user = Factory(:user)
    @application = Factory(:application)
    @store = Factory(:store)
    # Generate relation instance to avoid database rollback
    ::Relation::Purchaser.instance
  end

  context 'with oauth token from store' do
    before do
      controller.stub(:current_subject) { @store }
    end

    it "should create purchase" do
      post :create,
           customer: @user.actor_id,
           applications: [ { id: @application.id } ],
           format: :json

      response.status.should be(201)

      @application.contact_to!(@user).relation_ids.should include(::Relation::Purchaser.instance.id)
    end
  end

  context 'with oauth token from application' do
    before do
      controller.stub(:current_subject) { Factory(:application) }
    end

    it "should create purchase" do
      lambda {
        post :create,
             customer: @user.actor_id,
             applications: [ { id: @application.id } ],
             format: :json
      }.should raise_error(CanCan::AccessDenied)

      @application.contact_to!(@user).relation_ids.should_not include(::Relation::Purchaser.instance.id)
    end
  end

end
