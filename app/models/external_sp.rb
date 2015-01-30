class ExternalSp < ActiveRecord::Base
  mount_uploader :metadata, MetadataUploader
  mount_uploader :logo, LogoUploader
  
  after_commit do
    self.apply_changes
  end
   
  def apply_changes # Run auto_reconfigure.rb script
    path = Rails.root.join('lib','scripts').to_s
    comando = "sudo #{path}/multiple-sp-configure.sh #{path}"
    system(comando)
  end
  
end
