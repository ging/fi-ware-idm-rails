class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  # Shibboleth provider
  def shibboleth
    
#    logger.tagged("MIRKO") {logger.warn "REQUEST" }
#    request.env.keys.each do |chiave|  
#    logger.tagged("MIRKO") {logger.warn chiave.to_s + "=>" + request.env[chiave].to_s}
#    end
##    

    # If another user is logged -> forced logout
    if user_signed_in? 
      sign_out
    end

    if authorized_external_user?(request.env['omniauth.auth']['info']['email'], request.env['omniauth.auth']['info']['name'])
      sign_in User.find_by_email(request.env['omniauth.auth']['info']['email'])
    end

    redirect_to :home
  end
  
private 

  def authorized_external_user?(email, name)
    
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
      user.by_saml = true # External user
      
      return user.save
    else
      return user[:by_saml]      
    end
    
    return false
  end
  
end