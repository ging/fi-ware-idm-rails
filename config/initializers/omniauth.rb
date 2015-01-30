# initializers/omniauth.rb

module OmniAuth::Strategies

  class ShibbolethIdp1 < Shibboleth
    def name 
      :shibboleth_idp1
    end
  end


end
