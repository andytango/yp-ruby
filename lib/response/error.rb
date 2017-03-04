module Yp
  class Response
    class ValidationError < StandardError
      def initialize
        super('Gateway response could not be validated.')
      end
    end

    class InvalidSignatureError < ValidationError; end
    class MissingSignatureError < ValidationError; end
    class MissingResponseCodeError < ValidationError; end
    class MissingResponseMessageError < ValidationError; end
  end
end
