require_relative '../gateway_error'

module Yp
  class Response
    class Validator
      class Gateway

        def initialize(params)
          @params = params
        end

        def validate!
          is_valid_response_code? || (raise error_from_response)
        end

        private

        def is_valid_response_code?
          response_code.to_i <= 5
        end

        def error_from_response
          GatewayError.from_response_code(response_code, response_message)
        end

        def response_code
          @response_code ||= find_response_code
        end

        def find_response_code
          @params[:responseStatus] || (raise MissingResponseCodeError)
        end

        def response_message
          @params[:responseMessage] || (raise MissingResponseMessageError)
        end

      end
    end
  end
end