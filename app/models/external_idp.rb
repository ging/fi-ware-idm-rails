class ExternalIdp < ActiveRecord::Base
  mount_uploader :metadata, MetadataUploader
  mount_uploader :logo, LogoUploader
  
  def save
    
    base_route = '/users/auth/shibboleth_idp'

    # Route generation
    next_idp = ActiveRecord::Base.connection.select_one("SELECT IFNULL(MAX(CAST(SUBSTRING(route, LENGTH(\"#{base_route}\")+1) AS UNSIGNED))+1,1) as next_idp FROM external_idps")['next_idp']
    self.route =  base_route + next_idp.to_s
    #logger.tagged("MIRKO") {logger.warn "SAVE"}
    super
    #logger.tagged("MIRKO") {logger.warn "SAVE2"}
    # Runs the script
    self.apply_changes
  
  end

  def destroy
    super
    self.apply_changes
  end
  
  def apply_changes # Run auto_reconfigure.rb script
    
    path = Rails.root.join('lib','scripts').to_s
    comando = "sudo #{path}/multiple-idp-configure.sh #{path}"
    #logger.tagged("MIRKO") {logger.warn comando}
    system(comando)
  end
  
end
