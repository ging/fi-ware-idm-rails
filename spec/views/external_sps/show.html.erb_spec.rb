require 'spec_helper'

describe "external_sps/show" do
  before(:each) do
    @external_sp = assign(:external_sp, stub_model(ExternalSp))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
