require 'signing_hash_creator'

module Yp
  class Response
    class Validator
      class SigningKey

        def initialize(params, signature)
          @params = params
          @signature = signature
        end

        def validate!
          has_valid_signing_key? || (raise InvalidSignatureError)
        end

        private

        def has_valid_signing_key?
          their_signing_key == our_signing_key
        end

        def their_signing_key
          @params[:signature] || (raise MissingSignatureError)
        end

        def our_signing_key
          SigningHashCreator.new(signing_key_params, @signature).create
        end

        def signing_key_params
          @params.reject { |k, _| k == :signature }
        end

      end
    end
  end
end