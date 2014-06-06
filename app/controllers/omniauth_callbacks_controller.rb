class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  # Shibboleth provider
  def shibboleth
#    
#    logger.tagged("MIRKO") {logger.warn "REQUEST" }
#    request.env.keys.each do |chiave|  
#    logger.tagged("MIRKO") {logger.warn chiave.to_s + "=>" + request.env[chiave].to_s}
#    end
    
    # If another user is logged -> forced logout
    if user_signed_in? 
      sign_out
    end

    # Check if the access request is made by an authorized IDP
    info_idp = ExternalIdp.find_by_url(request.env['REQUEST_URI'].to_s)
    if !info_idp.blank?
      if info_idp[:enabled]

        mod_email = request.env['omniauth.auth']['info']['email'] + "_" + info_idp[:mark]
        if authorized_external_user?(mod_email, request.env['omniauth.auth']['info']['name'], info_idp[:id])
          sign_in User.find_by_email(mod_email)
          set_flash_message :notice, :success, :kind => info_idp[:description]
        end

      end
    end
    
    redirect_to :home
  end
  
private 

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