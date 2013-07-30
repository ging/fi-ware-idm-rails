class Permission
  class Custom < Permission
    belongs_to :actor

    validates :name, :action, :object, presence: true

    def name
      read_attribute(:name)
    end

    def description
      read_attribute(:description)
    end
  end
end
