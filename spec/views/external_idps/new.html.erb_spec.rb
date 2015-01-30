require 'spec_helper'

describe "external_idps/new" do
  before(:each) do
    assign(:external_idp, stub_model(ExternalIdp).as_new_record)
  end

  it "renders new external_idp form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", external_idps_path, "post" do
    end
  end
end
