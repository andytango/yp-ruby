require "spec_helper"

describe Yp::Verify do

  Given(:params) do
    {
      merchantID: '101381',
      countryCode: 826,
      currencyCode:  826,
      cardNumber:  '4012001037141112',
      cardExpiryMonth:  12,
      cardExpiryYear:  15,
      cardCVV:  '083',
      customerName:  'Yorkshire Payments',
      customerEmail:  'support@yorkshirepayments.com',
      customerAddress:  '16 Test Street',
      customerPostCode:  'TE15 5ST',
      orderRef:  'Test purchase'
    }
  end

  context 'has the correct action, type and amount value' do
    Given(:sale) { Yp::Verify.new('signature', key: 'value') }
    Then do
      sale.params == {
          action: 'VERIFY',
          type: 1,
          key: 'value',
          amount: 0
      }
    end
  end

  describe 'verifies', vcr: { :cassette_name => 'verify_success' } do
    Given(:transaction) { params.merge({ amount: 102 }) }
    Given(:verify) do
      Yp::Verify.new('Engine0Milk12Next', transaction)
    end
    When(:result) { verify.send! }
    Then { result[:state] == 'verified' }
    And { result[:merchantID] == transaction[:merchantID] }
  end

end