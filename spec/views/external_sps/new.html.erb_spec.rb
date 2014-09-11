require 'spec_helper'

describe "external_sps/new" do
  before(:each) do
    assign(:external_sp, stub_model(ExternalSp).as_new_record)
  end

  it "renders new external_sp form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", external_sps_path, "post" do
    end
  end
end
