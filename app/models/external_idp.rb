class ExternalIdp < ActiveRecord::Base
  mount_uploader :metadata, MetadataUploader
  mount_uploader :logo, LogoUploader
  
  before_create do
    
    # Calculate the next id
    base_route = '/users/auth/shibboleth_idp'

    # Route generation
    next_idp = ActiveRecord::Base.connection.select_one("SELECT IFNULL(MAX(CAST(SUBSTRING(route, LENGTH(\"#{base_route}\")+1) AS UNSIGNED))+1,1) as next_idp FROM external_idps")['next_idp']
    self.route =  base_route + next_idp.to_s
  end
  
  before_destroy do
    
    listUsers = User.find_by_sql('SELECT users.id FROM users JOIN external_idps ON users.ext_idp=external_idps.id')
    listUsers.each do |user|
      User.find(user.id).destroy
    end

  end
  
  after_commit do

    self.apply_changes
    
  end
   
  def apply_changes # Run auto_reconfigure.rb script
    path = Rails.root.join('lib','scripts').to_s
    comando = "sudo #{path}/multiple-idp-configure.sh #{path}"
    system(comando)
  end
  
end
