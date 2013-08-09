module FiWareIdm
  module Thales
    mattr_accessor :enable
    @@enable = false

    mattr_accessor :url, :client_certificate, :key, :ca_certificate, :passphrase

    class << self
      def setup
        yield self
      end
    end
  end
end
