require 'response/parser'
require 'response/error'
require 'response/validator'

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
      Validator.new(parsed, @signature).validate!
    end

    def parsed
      @parsed ||= parse_params
    end

    def parse_params
      Parser.new(@params).parse.tap { |parsed| @logger.log_response(parsed) }
    end

  end
end