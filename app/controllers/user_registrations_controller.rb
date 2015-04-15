class UserRegistrationsController < Devise::RegistrationsController
  def create
    
    # Limiting registrations
  	if User.where(:created_at => DateTime.new(2015, 4, 15, 00, 00, 0)..Time.now).count > 100
  		build_resource
  		resource.errors.add(:base, "Unfortunately, the number of Trial Users able to has reached its limit and we cannot serve your request at this moment.")
  		@maxusers = true
  		return render :new
  	end

    if simple_captcha_valid?
      super                   
    else                         
      build_resource         
      resource.errors.add(:base, t('simple_captcha.error')) if resource.valid?
      render :new                                 
    end               
  end    
end