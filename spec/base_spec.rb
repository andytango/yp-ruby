require "spec_helper"

describe Yp::Base do

  Given(:params) do
    {
      merchantID: '101381',
      action: 'SALE',
      countryCode: 826,
      currencyCode:  826,
      amount:  TestAmounts.accepted,
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

  Given(:serialized_transaction) do
      'action=SALE&amount=1001&cardCVV=083&cardExpiryMonth=12&cardExpiryYear' +
      '=15&cardNumber=4012001037141112&countryCode=826&currencyCode=826&cust' +
      'omerAddress=16+Test+Street&customerEmail=support%40yorkshirepayments.' +
      'com&customerName=Yorkshire+Payments&customerPostCode=TE15+5ST&merchan' +
      'tID=101381&orderRef=Test+purchase&type=1'
  end

  context 'version number' do
    Then { !Yp::VERSION.nil? }
  end

  describe 'send', vcr: { :cassette_name => 'example_transaction_docs' } do
    Given(:transaction) { Yp::Base.new('Engine0Milk12Next', params) }
    When(:result) { transaction.send! }
    Then { result[:state] == 'captured' }
    And { result[:merchantID] == params[:merchantID] }
  end
end
