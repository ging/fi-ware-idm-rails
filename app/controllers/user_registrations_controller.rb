class UserRegistrationsController < Devise::RegistrationsController
  include FiWareIdm::Controllers::Shibboleth
  
  def create
    if simple_captcha_valid?
      super                   
    else                         
      build_resource         
      resource.errors.add(:base, t('simple_captcha.error')) if resource.valid?
      render :new                                 
    end               
  end    
  
  def destroy
    
    shibboleth_logout    
    
    super
  end
  
end