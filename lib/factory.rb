module Yp
  class Factory

    def initialize(merchant_id:, password: nil, signature_key:)
      @defaults = default_params(merchant_id, password)
      @signature_key = signature_key
    end

    def sale(params)
      Sale.new(@signature_key,  @defaults.merge(params))
    end

    private

    def default_params(id, pwd)
      { merchantID: id }.tap do |hash|
        hash[:merchantPwd] = pwd unless pwd.nil?
      end
    end

  end
end