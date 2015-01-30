# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class UserSessionsController < Devise::SessionsController
  include FiWareIdm::Controllers::Shibboleth
  
  def destroy
    
    shibboleth_logout    
    
    super
  end
  
end
