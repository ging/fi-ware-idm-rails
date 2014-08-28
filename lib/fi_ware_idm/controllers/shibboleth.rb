module FiWareIdm
  module Controllers
    module Shibboleth
      
      def shibboleth_logout
        
        if !current_user.nil? && current_user.ext_idp?
          
          # Recover shibboleth session cookie
          cookies.each do |cookie| 

            if ! cookie[0].index("_shibsession_").nil? # Find it! Make a GET for shibboleth Logout

              shib_cookie = {"Cookie" => cookie[0] + "=" + cookie[1]}
              RestClient.get(root_url + "Shibboleth.sso/Logout",shib_cookie)

              # Delete cookie        
              cookies[cookie[0]] = { :expires => Time.at(0) }        
            end
          end
        end
        
      end
      
    end
  end
end
    