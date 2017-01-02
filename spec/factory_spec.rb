require "spec_helper"

describe Yp::Factory do

  context 'no password' do
    Given(:factory) do
      Yp::Factory.new(merchant_id: 101381, signature_key: 'secret')
    end
    When(:params) { factory.sale({}).params }
    Then { params == { merchantID: 101381, action: 'SALE' } }
  end

  context 'with password' do
    Given(:factory) do
      Yp::Factory.new(merchant_id: 101381,
                      signature_key: 'secret',
                      password:'pass')
    end
    When(:params) { factory.sale({}).params }
    Then do
      params == { merchantID: 101381, action: 'SALE', merchantPwd: 'pass' }
    end
  end

end