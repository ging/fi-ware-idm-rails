class XacmlFile

  Strxmlns = "urn:oasis:names:tc:xacml:2.0:policy:schema:os"
  StrPolicyCombiningAlgIdPermitOverrides = "urn:oasis:names:tc:xacml:1.0:policy-combining-algorithm:permit-overrides"
  StrRuleCombiningAlgIdPermitOverrides = "urn:oasis:names:tc:xacml:1.0:rule-combining-algorithm:permit-overrides"
  StrDataType = "http://www.w3.org/2001/XMLSchema#string"
  StrSubResourceId = "urn:thales:xacml:2.0:resource:sub-resource-id"
  StrResourceId = "urn:oasis:names:tc:xacml:1.0:resource:resource-id"
  StrRoleId = "urn:oasis:names:tc:xacml:2.0:subject:role"
  StrActionId = "urn:oasis:names:tc:xacml:1.0:action:action-id"
  StrFuncStrIsIn = "urn:oasis:names:tc:xacml:1.0:function:string-is-in"
  StrFuncAnd = "urn:oasis:names:tc:xacml:1.0:function:and"
  StrFuncStrEqual ='urn:oasis:names:tc:xacml:1.0:function:string-equal'

  def create_XACMLpolicy(application)
    roles = application.roles
    appName = application.name

    xmltitle = Nokogiri::XML('<?xml version = "1.0" encoding = "UTF-8" standalone ="yes"?>')
    builder = Nokogiri::XML::Builder.with(xmltitle) do |xml|
      xml.PolicySet(:xmlns => Strxmlns, :PolicySetId => application.id, :Version => '1.0', :PolicyCombiningAlgId => StrPolicyCombiningAlgIdPermitOverrides) {
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
    xml.Policy(:PolicyId => role.id, :Version => "1.0", :RuleCombiningAlgId => StrRuleCombiningAlgIdPermitOverrides){
      xml.Description 'Role permissions policy file for '+role.name 
      xml.Target{
        xml.Subjects{
          xml.Subject{
            xml.SubjectMatch(:MatchId => StrFuncStrEqual) {
              xml.AttributeValue(role.name, :DataType => StrDataType)
              xml.SubjectAttributeDesignator(:DataType => StrDataType, :AttributeId => StrRoleId, :MustBePresent => "true")
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
    xml.Rule(:RuleId => "role_#{ role.id }_can_#{ action.to_s.gsub(/\s/, '') }_#{ object.to_s.gsub(/\s/, '') }", :Effect =>'Permit'){
      xml.Description(role.name + ' can ' + action.to_s + ' ' + object.to_s)
      xml.Target {
        xml.Resources {
          xml.Resource {
            xml.ResourceMatch(:MatchId => StrFuncStrEqual) {
              xml.AttributeValue(object, :DataType => StrDataType)
              xml.ResourceAttributeDesignator(:AttributeId =>StrResourceId, :DataType =>StrDataType, :MustBePresent => "true")
            }
          }
        }
        xml.Actions {
          xml.Action {
            xml.ActionMatch (:MatchId => StrFuncStrEqual) {
              xml.AttributeValue(action.to_s, :DataType => StrDataType)
              xml.ActionAttributeDesignator(:AttributeId =>StrActionId, :DataType =>StrDataType, :MustBePresent => "true")
            }
          }
        }
      }
    }
  end
end
