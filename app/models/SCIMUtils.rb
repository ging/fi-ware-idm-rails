# encoding: utf-8

class SCIMUtils

  def self.error(msg,code=401)
	{
		schemas: ["urn:scim:schemas:core:2.0:Error"],
		Errors: [
			{
				description: msg,
				code: code.to_s
			}
		]
	}
  end

end