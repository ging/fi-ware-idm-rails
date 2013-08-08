#xacml_spec.rb
require 'spec_helper'
require 'nokogiri' 

describe XacmlFile do 
  describe "#create rule" do
    it "test create rule" do
      p = XacmlFile.new

      # permission.action = "manage"
      # permission.object = "contacts"
      # role.name = "Manager"
      # role.permissions = permission
      
      # obj = double()
      # allow(obj).to

      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml<<p.create_rule(xml, "manager", "manage","contact")
      end

      puts builder.to_xml
    end
  end

  describe "xacml policy" do
    
    let(:permission) do
      mock_model permission, :action => "manage", :object =>"contact"
    end
    let(:role) do
      mock_model role, :name =>"Manager", :permissions => permission
    end
    it "show create policy" do
      p = XacmlFile.new

      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml<<p.create_policy(xml, "Dummy", role)
      end
      builder.to_xml
    end
  end


  
end