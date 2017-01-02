require 'version'
require 'rest-client'
require 'digest'
require 'erb'


module Yp
  class Base
    def initialize(signature_key, **params)
      @params = params
      @signature_key = signature_key
    end

    def body
      @params.clone.tap { |params|  params[:signature] = create_signing_hash }
    end

    def create_signing_hash
      self.class.digest(self.class.serialize_params(@params) + @signature_key)
    end

    class << self
      def digest(str_params)
        Digest::SHA512.hexdigest str_params
      end

      def serialize_params(params)
        uri_string_from_hash(params)
      end

      private

      def uri_string_from_hash(hash)
        hash.map { |key, value| uri_query_param(key, value) }.sort.join '&'
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
