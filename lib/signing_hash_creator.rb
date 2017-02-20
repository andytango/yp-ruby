module Yp
  class SigningHashCreator
    def initialize(params, signature_key)
      @params = params
      @signature_key = signature_key
    end

    def create
      self.class.digest(self.class.serialize_params(@params) + @signature_key)
    end

    class << self

      def digest(str_params)
        Digest::SHA512.hexdigest str_params
      end

      def serialize_params(params)
        params.map { |key, value| uri_query_param(key, value) }.sort.join('&')
      end

      def uri_query_param(key, value)
        encode_url_component(key) + '=' + encode_url_component(value)
      end

      def encode_url_component(key)
        ERB::Util::url_encode(key).gsub(/%20/, '+')
      end

    end
  end
end