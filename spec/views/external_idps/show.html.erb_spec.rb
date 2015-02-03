require 'spec_helper'

describe "external_idps/show" do
  before(:each) do
    @external_idp = assign(:external_idp, stub_model(ExternalIdp))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
