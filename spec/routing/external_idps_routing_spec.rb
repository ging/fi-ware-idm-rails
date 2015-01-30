require "spec_helper"

describe ExternalIdpsController do
  describe "routing" do

    it "routes to #index" do
      get("/external_idps").should route_to("external_idps#index")
    end

    it "routes to #new" do
      get("/external_idps/new").should route_to("external_idps#new")
    end

    it "routes to #show" do
      get("/external_idps/1").should route_to("external_idps#show", :id => "1")
    end

    it "routes to #edit" do
      get("/external_idps/1/edit").should route_to("external_idps#edit", :id => "1")
    end

    it "routes to #create" do
      post("/external_idps").should route_to("external_idps#create")
    end

    it "routes to #update" do
      put("/external_idps/1").should route_to("external_idps#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/external_idps/1").should route_to("external_idps#destroy", :id => "1")
    end

  end
end
