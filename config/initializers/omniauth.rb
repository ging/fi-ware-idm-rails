# initializers/omniauth.rb

module OmniAuth::Strategies

  class ShibbolethIdp1 < Shibboleth
    def name 
      :shibboleth_idp1
    end 
  end

  class ShibbolethIdp2 < Shibboleth
    def name 
      :shibboleth_idp2
    end 
  end

  class ShibbolethIdp3 < Shibboleth
    def name 
      :shibboleth_idp3
    end 
  end

  class ShibbolethIdp4 < Shibboleth
    def name 
      :shibboleth_idp4
    end 
  end
  
end