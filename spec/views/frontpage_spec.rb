require 'spec_helper'

describe 'layouts/application' do
  before do
    view.stub(:user_signed_in?).and_return(false)
  end

  it "does not include social stream snippet" do
    render

    expect(rendered).not_to include("Social Stream, a framework")
  end
end
