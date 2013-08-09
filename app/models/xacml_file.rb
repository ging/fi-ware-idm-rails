class XacmlFile

  Strxmlns = "urn:oasis:names:tc:xacml:2.0:policy:schema:os"
  StrPolicyCombiningAlgIdPermitOverrides = "urn:oasis:names:tc:xacml:1.0:policy-combining-algorithm:permit-overrides"
  StrRuleCombiningAlgIdPermitOverrides = "urn:oasis:names:tc:xacml:1.0:rule-combining-algorithm:permit-overrides"
  StrDataType = "http://www.w3.org/2001/XMLSchema#string"
  StrSubResourceId = "urn:thales:xacml:2.0:resource:sub-resource-id"
  StrResourceId = "urn:oasis:names:tc:xacml:1.0:resource:resource-id"
  StrActionId = "urn:oasis:names:tc:xacml:1.0:action:action-id"
  StrFuncStrIsIn = "urn:oasis:names:tc:xacml:1.0:function:string-is-in"
  StrFuncAnd = "urn:oasis:names:tc:xacml:1.0:function:and"
  StrFuncStrEqual ='urn:oasis:names:tc:xacml:1.0:function:string-equal'

  def create_policyset(appName, roles)
    #puts "xacml_file.createPolicySet method now. appName is: "+appName

    xmltitle = Nokogiri::XML('<?xml version = "1.0" encoding = "UTF-8" standalone ="yes"?>')
    builder = Nokogiri::XML::Builder.with(xmltitle) do |xml|
      xml.PolicySet(:xmlns => Strxmlns, :PolicySetId => appName+'_policyset', :Version => '1.0', :PolicyCombiningAlgId => StrPolicyCombiningAlgIdPermitOverrides) {
        xml.Description(appName+' policyset')
        xml.Target
        roles.each do |role|
          create_policy(xml, role)
        end
      }  
    end
  end

  def create_policy(xml, role)
    #create policy node
    xml.Policy(:PolicyId => role.name, :Version => "1.0", :RuleCombiningAlgId => StrRuleCombiningAlgIdPermitOverrides){
      xml.Description 'Role permissions policy file for '+role.name 
      xml.Target{
        xml.Resources{
          xml.Resource{
            xml.ResourceMatch(:MatchId => StrFuncStrEqual) {
              xml.AttributeValue(role.name, :DataType => StrDataType)
              xml.ResourceAttributeDesignator(:DataType => StrDataType, :AttributeId => StrResourceId, :MustBePresent => "true")
            }
          }
        }
      }
      role.permissions.each do |permission|
        action = permission.action
        object = permission.object

        if object == nil 
          object="null"
        end

        create_rule(xml, role, action, object) 
      end
    }

    
  end

  def create_rule(xml, role, action, object )
    #create all the rules 
    xml.Rule(:RuleId =>role.name+'_can_'+ action.to_s+'_'+object.to_s, :Effect =>'Permit'){
      xml.Description(role.name+' can '+ action.to_s+' '+object.to_s)
      xml.Condition{
        xml.Apply(:FunctionId =>StrFuncAnd){
          xml.Apply(:FunctionId => StrFuncStrIsIn){
            xml.AttributeValue(object, :DataType => StrDataType)
            xml.ResourceAttributeDesignator(:AttributeId =>StrSubResourceId, :DataType =>StrDataType, :MustBePresent => "true")
          }
          xml.Apply(:FunctionId => StrFuncStrIsIn){
            xml.AttributeValue(action.to_s, :DataType => StrDataType)
            xml.ActionAttributeDesignator(:AttributeId =>StrActionId, :DataType =>StrDataType, :MustBePresent => "true")
          }
        }
      }

    }
  end

  def create_XACMLpolicy(application)
    roles = application.roles
    appName = application.name
    create_policyset(appName, roles)
  end
end