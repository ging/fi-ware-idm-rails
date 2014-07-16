class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  # Shibboleth provider
  def shibboleth_idp1

    autenticate_sso_user(request)
        
    redirect_to :home
  end

  # Shibboleth provider
  def shibboleth_idp2
    
    # Check if the access request is made by an authorized IDP
    autenticate_sso_user(request)
    
    redirect_to :home
  end

  # Shibboleth provider
  def shibboleth_idp3
    
    # Check if the access request is made by an authorized IDP
    autenticate_sso_user(request)
    
    redirect_to :home
  end

  # Shibboleth provider
  def shibboleth_idp4
    
    # Check if the access request is made by an authorized IDP
    autenticate_sso_user(request)
    
    redirect_to :home
  end
  
private 

  def autenticate_sso_user(requestVar)
    info_idp = ExternalIdp.find_by_url(requestVar.env['REQUEST_URI'].to_s)

    if !info_idp.blank?

      if info_idp[:enabled]

        begin
          mod_email = requestVar.env['omniauth.auth']['info']['email'] + "_" + info_idp[:mark]
        rescue    
          mod_email = nil
        end
        
        if !mod_email.nil?
          if authorized_external_user?(mod_email, requestVar.env['omniauth.auth']['info']['name'], info_idp[:id])
            sign_in User.find_by_email(mod_email)
            set_flash_message :notice, :success, :kind => info_idp[:description]
          end
        end
      end
    end
  end
  
  def authorized_external_user?(email, name, idp_mark)
    
    user = User.find_by_email(email)
    
    # If the user not exist, create it!
    if user.nil?
      password = Devise.friendly_token.first(12) # Generic password
      user = User.new      
      user.email = email
      user.password = password
      user.password_confirmation = password
      user.skip_confirmation!
      user.name = name
      user.ext_idp = idp_mark 
      
      return user.save
    else
      return true 
    end
    
    return false
  end
  
end