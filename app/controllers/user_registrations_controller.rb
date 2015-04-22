class UserRegistrationsController < Devise::RegistrationsController
  
  def create
    isAdmin = ((!Site.current.config[:password].nil?) and (params[:premium_password]===Site.current.config[:password]))
    unless isAdmin
      # Limiting registrations
    	if User.where(:created_at => DateTime.new(2015, 4, 16, 9, 0, 0)..Time.now).count > 100
    		build_resource
    		resource.errors.add(:base, "Unfortunately, the number of Trial Users able to has reached its limit and we cannot serve your request at this moment.")
    		@maxusers = true
    		return render :new
    	end
    end

    if simple_captcha_valid?
      super                   
    else                         
      build_resource
      resource.errors.add(:base, t('simple_captcha.error')) if resource.valid?
      render :new                                 
    end               
  end  

  def premium_registration
    build_resource

    isAdmin = ((!Site.current.config[:password].nil?) and (params[:password]===Site.current.config[:password]))

    if isAdmin
      @premium_registration = true
    else
      resource.errors.add(:base, "Wrong password")
    end

    render :new
  end

end