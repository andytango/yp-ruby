module Yp
  class Base
    TYPE = {
        ecom: 1,
        moto: 2,
        ca: 9
    }.freeze

    attr_reader :params

    def initialize(signature_key, type: :ecom, **params)
      @params = transaction_params(params, type)
      @signature_key = signature_key
    end

    def body
      @params.clone.tap do |params|
        params[:signature] = create_signing_hash
        Yp.logger.info "[YP] Sending transaction with params #{params.to_s}"
      end
    end

    def create_signing_hash
      self.class.digest(self.class.serialize_params(@params) + @signature_key)
    end

    def send
      if block_given?
        RestClient.post(URL, body) do |response|
          yield(self.class.parse response)
        end
      else
        self.class.parse(RestClient.post(URL, body))
      end
    end

    protected

    def default_params
      {}
    end

    def action_params
      {}
    end

    private

    def transaction_params(params, type)
      params
          .merge(default_params)
          .merge(transaction_type(type))
          .merge(action_params)
    end

    def transaction_type(type)
      { type: TYPE[type] }
    end

    class << self

      def digest(str_params)
        Digest::SHA512.hexdigest str_params
      end

      def serialize_params(params)
        uri_string_from_hash(params)
      end

      def parse(response)
        ruby_hash_from_response(CGI::parse(response)).tap do |parsed|
          Yp.logger.info "[YP] Response received with params #{parsed}"
        end
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

      def ruby_hash_from_response(hash)
        hash.reduce({}) do |memo, (key, value)|
          memo.merge({key.to_sym => value.first})
        end
      end

    end
  end
end