require 'spec_helper'

describe "external_idps/index" do
  before(:each) do
    assign(:external_idps, [
      stub_model(ExternalIdp),
      stub_model(ExternalIdp)
    ])
  end

  it "renders a list of external_idps" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
