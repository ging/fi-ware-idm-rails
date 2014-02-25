class UserRegistrationsController < Devise::RegistrationsController
  def create
    if simple_captcha_valid?
      super                   
    else                         
      build_resource         
      resource.errors.add(:base, t('simple_captcha.error')) if resource.valid?
      render :new                                 
    end               
  end    
end