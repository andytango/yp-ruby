require 'yaml'

module Yp
  class Response
    class GatewayError < StandardError

      def self.from_response_code(code, message)
        Factory.new(code, message).error
      end

      class Factory

        class << self
          def error_map
            @error_map ||= load_error_map
          end

          private

          def load_error_map
            YAML.load(File.read('data/gateway_responses.yml'))
          end
        end

        def initialize(code, message)
          @code = code
          @message = message
        end

        def error
          if is_missing_field?
            MissingFieldError.new(missing_field)
          elsif is_invalid_field?
            InvalidFieldError.new(invalid_field)
          else
            GatewayError.new(@message)
          end
        end

        private

        def is_missing_field?
          !missing_field.nil?
        end

        def missing_field
          @missing_field ||= mapped_error(:missing_field)
        end

        def is_invalid_field?
          !invalid_field.nil?
        end

        def invalid_field
          @invalid_field ||= mapped_error(:invalid_field)
        end

        def mapped_error(sym)
          Factory.error_map[sym.to_s][@code.to_i]
        end

      end
    end

    class MissingFieldError < GatewayError; end
    class InvalidFieldError < GatewayError; end
  end
end