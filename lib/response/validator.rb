require 'signing_hash_creator'

module Yp
  class Response
    class Validator

      def initialize(response)
        @response = response
      end

      def valid?
        has_valid_signing_key?
      end

      private

      def has_valid_signing_key?
        true
      end

    end
  end
end