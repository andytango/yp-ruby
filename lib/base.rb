require 'transaction_logger'
require 'signing_hash_creator'

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

    def body
      @params.clone.tap do |params|
        params[:signature] = create_signing_hash
        TransactionLogger.log_request(params)
      end
    end

    def create_signing_hash
      SigningHashCreator.new(@params, @signature_key).create
    end

    class << self

      def parse(response)
        ruby_hash_from_response(CGI::parse(response)).tap do |parsed|
          TransactionLogger.log_response(parsed)
        end
      end

      private

      def ruby_hash_from_response(hash)
        hash.reduce({}) do |memo, (key, value)|
          memo.merge({key.to_sym => value.first})
        end
      end

    end
  end
end