class OmniauthCallbacksController < Devise::OmniauthCallbacksController

private 

  def autenticate_sso_user(requestVar)
    
    # Removed callback path
    info_idp = ExternalIdp.find_by_route(requestVar.env['REQUEST_URI'].to_s.sub('/callback',''))
    if !info_idp.blank?
      if info_idp[:enabled]
        logger.tagged("MIRKO") {logger.warn "enabled" }
        begin
          email = requestVar.env['omniauth.auth']['info']['email']
        rescue    
          email = nil
        end

        if !email.nil?
          id_user = authorized_external_user(email, requestVar.env['omniauth.auth']['info']['name'], info_idp[:id])
          if id_user > 0
            sign_in User.find(id_user)
            set_flash_message :notice, :success, :kind => info_idp[:description]
          end
        end
      end
    end
  end
  
  def authorized_external_user(email, name, idp_mark)
    
    # check if the user already exists
    user = User.find(:first, :include => :actor, :conditions => {'actors.email' => email, :ext_idp => idp_mark})
    if !user.nil? # Find it!
      return user.id
    end

    password = Devise.friendly_token.first(12) # Generic password
    user = User.new      
    user.email = email
    user.password = password
    user.password_confirmation = password
    user.skip_confirmation!
    user.name = name
    user.ext_idp = idp_mark 
      
    user.save
    return user.id
    
  end
  
end