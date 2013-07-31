class Permission
  class Custom < Permission
    belongs_to :actor

    validates :name, :action, :object, presence: true

    def title(options = {})
      name
    end

    def description(options = {})
      read_attribute(:description)
    end
  end
end
