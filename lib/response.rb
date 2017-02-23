require 'response/parser'
require 'response/validator'

module Yp
  class Response
    def initialize(params, logger)
      @params = params
      @logger = logger
    end

    def parse_and_validate
      parsed if valid?
    end

    private

    def parsed
      @parsed ||= parse_params
    end

    def parse_params
      Parser.new(@params).parse.tap { |parsed| @logger.log_response(parsed) }
    end

    def valid?
      Validator.new(self).valid?
    end

  end
end