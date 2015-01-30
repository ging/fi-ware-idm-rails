require 'spec_helper'

describe "external_idps/edit" do
  before(:each) do
    @external_idp = assign(:external_idp, stub_model(ExternalIdp))
  end

  it "renders the edit external_idp form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", external_idp_path(@external_idp), "post" do
    end
  end
end
