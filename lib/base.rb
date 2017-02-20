require 'transaction_logger'
require 'signing_hash_creator'
require 'response'

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
          yield(parse_and_validate response)
        end
      else
        parse_and_validate(RestClient.post(URL, body))
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

    def parse_and_validate(response)
      Response.new(response, TransactionLogger).parse_and_validate
    end

  end
end