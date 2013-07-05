require 'spec_helper'

describe 'home/index' do
  let(:user) { stub_model(User, {}) }
  let(:organization) { stub_model(Organization, {}) }

  before do
    view.stub(:user_signed_in?).and_return(true)
    view.stub(:current_user).and_return(user)
  end

  describe 'user authenticated' do
    before do
      view.stub(:current_subject).and_return(user)
    end

    it "renders" do
      render

      expect(rendered).to include("Organizations")
    end
  end

  describe 'organization session' do
    before do
      view.stub(:current_subject).and_return(organization)
    end

    it "renders" do
      render

      expect(rendered).to include("Members")
    end
  end
end
