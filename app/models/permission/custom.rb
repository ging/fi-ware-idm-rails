class Permission
  class Custom < Permission
    belongs_to :actor

    validates :name, presence: true

    validate :rest_xor_xml

    

    def title(options = {})
      name
    end

    def description(options = {})
      read_attribute(:description)
    end

    private

    def rest_xor_xml
      if !((object.blank? && action.blank?) ^ xml.blank?)
        errors[:base] << "Specify a HTTP ACTION and PATH or a XACML, not both"
      end
    end
  end
end
