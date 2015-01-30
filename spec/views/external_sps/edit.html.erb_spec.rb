require 'spec_helper'

describe "external_sps/edit" do
  before(:each) do
    @external_sp = assign(:external_sp, stub_model(ExternalSp))
  end

  it "renders the edit external_sp form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", external_sp_path(@external_sp), "post" do
    end
  end
end
