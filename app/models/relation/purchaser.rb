# User or Organizations adquires an application
class Relation::Purchaser < Relation::Single
  PERMISSIONS = [
    [ 'get', 'relation/custom' ]
  ]
    
  class << self
    def create_activity?
      false
    end
  end
end
