require_relative 'validator/signing_key'

module Yp
  class Response
    class Validator

      class InvalidSignatureError < StandardError; end
      class MissingSignatureError < StandardError; end

      def initialize(params, signature)
        @params = params
        @signature = signature
      end

      def valid?
        SigningKey.new(@params, @signature).valid?
      end

    end
  end
end