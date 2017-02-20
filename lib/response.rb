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

    def valid?
      true
    end

    def parsed
      @parsed ||= parse_params
    end

    def parse_params
      ruby_hash_from_response(CGI::parse(@params)).tap do |parsed|
        logger.log_response(parsed)
      end
    end

    def ruby_hash_from_response(hash)
      hash.reduce({}) do |memo, (key, value)|
        memo.merge({key.to_sym => value.first})
      end
    end

    def logger
      @logger
    end

  end
end