require "spec_helper"

describe ExternalSpsController do
  describe "routing" do

    it "routes to #index" do
      get("/external_sps").should route_to("external_sps#index")
    end

    it "routes to #new" do
      get("/external_sps/new").should route_to("external_sps#new")
    end

    it "routes to #show" do
      get("/external_sps/1").should route_to("external_sps#show", :id => "1")
    end

    it "routes to #edit" do
      get("/external_sps/1/edit").should route_to("external_sps#edit", :id => "1")
    end

    it "routes to #create" do
      post("/external_sps").should route_to("external_sps#create")
    end

    it "routes to #update" do
      put("/external_sps/1").should route_to("external_sps#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/external_sps/1").should route_to("external_sps#destroy", :id => "1")
    end

  end
end
