#xacml_spec.rb
require 'spec_helper'
require 'nokogiri' 

describe xacml_file do 
  describe "#createRule" do
    it "create rule success" do
      p = xacml_file.new

      builder = Nokogiri::XML::Builder.new('encoding' => 'UTF-8', 'standalone' => 'yes') do |xml|
        p.createRule(xml, "Manager","manage","contacts").to_xml()
      end
    end
  end

  
end