module Yp
  class Response
    class Parser

      def initialize(params)
        @params = params
      end

      def parse
        ruby_hash_from_response(parse_string)
      end

      private

      def parse_string
        CGI::parse(@params)
      end

      def ruby_hash_from_response(hash)
        hash.reduce({}) do |memo, (key, value)|
          memo.merge({key.to_sym => value.first})
        end
      end

    end
  end
end