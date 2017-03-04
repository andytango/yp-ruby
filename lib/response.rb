require 'response/parser'
require 'response/error'
require 'response/validator'
require 'response/error_logger'

module Yp
  class Response
    def initialize(signature, params, logger)
      @signature = signature
      @params = params
      @logger = logger
    end

    def parse_and_validate
      validate!
      parsed
    end

    private

    def validate!
      ErrorLogger.new(@logger).log do
        Validator.new(parsed, @signature).validate!
      end
    end

    def parsed
      @parsed ||= parse_params
    end

    def parse_params
      Parser.new(@params).parse.tap { |parsed| @logger.log_response(parsed) }
    end

  end
end