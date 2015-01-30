require 'spec_helper'

describe "ExternalSps" do
  describe "GET /external_sps" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get external_sps_path
      response.status.should be(200)
    end
  end
end
