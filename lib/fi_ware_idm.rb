module FiWareIdm
  mattr_accessor :domain
  @@domain = 'account.lab.fi-ware.eu'

  mattr_accessor :subdomain
  @@subdomain = 'lab.fi-ware.eu'

  mattr_accessor :sender
  @@sender = 'no-reply@account.lab.fi-ware.eu'

  mattr_accessor :name
  @@name = "FI-LAB"

  mattr_accessor :bug_receivers
  @@bug_receivers = []

  class << self
    def setup
      yield self
    end
  end
end
