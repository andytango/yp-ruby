require_relative 'validator/signing_key'
require_relative 'validator/gateway'

module Yp
  class Response
    class Validator

      class InvalidSignatureError < StandardError; end
      class MissingSignatureError < StandardError; end
      class MissingResponseCodeError < StandardError; end
      class MissingResponseMessageError < StandardError; end

      def initialize(params, signature)
        @params = params
        @signature = signature
      end

      def validate!
        SigningKey.new(@params, @signature).validate!
        Gateway.new(@params).validate!
      end

    end
  end
end