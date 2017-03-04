require_relative 'validator/signing_key'
require_relative 'validator/gateway'
require_relative 'validator/acquirer'

module Yp
  class Response
    class Validator
      def initialize(params, signature)
        @params = params
        @signature = signature
      end

      def validate!
        SigningKey.new(@params, @signature).validate!
        Gateway.new(@params).validate!
        Acquirer.new(@params).validate!
      end

    end
  end
end