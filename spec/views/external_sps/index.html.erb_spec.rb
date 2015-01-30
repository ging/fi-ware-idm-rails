require 'spec_helper'

describe "external_sps/index" do
  before(:each) do
    assign(:external_sps, [
      stub_model(ExternalSp),
      stub_model(ExternalSp)
    ])
  end

  it "renders a list of external_sps" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
