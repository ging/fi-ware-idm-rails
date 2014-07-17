class ExternalIdp < ActiveRecord::Base
  attr_accessible :enabled, :route, :url
end
