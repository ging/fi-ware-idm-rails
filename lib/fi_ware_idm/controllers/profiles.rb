module FiWareIdm
  module Controllers
    module Profiles
      extend ActiveSupport::Concern

      included do
        before_filter :redirect_to_subject, only: [ :show ]
      end

      private

      def redirect_to_subject
        redirect_to profile_or_current_subject
      end
    end
  end
end
