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

    context 'valid params' do
      Given(:transaction) { Yp::Base.new('Engine0Milk12Next', params) }
      When(:result) { transaction.send! }
      Then { result[:state] == 'captured' }
      And { result[:merchantID] == params[:merchantID] }
    end

    context 'invalid params' do
      Given(:invalid) { params.clone }
      When(:transaction) { Yp::Base.new('Engine0Milk12Next', invalid) }

      context 'missing mid', vcr: { :cassette_name => 'missing_mid' } do
        Given { invalid.delete(:merchantID) }
        Given(:error) { Yp::Response::MissingSignatureError }
        Then { expect { transaction.send! }.to raise_error(error) }
      end

      context 'missing card number',
          vcr: { :cassette_name => 'missing_card_number' } do

        Given { invalid.delete(:cardNumber) }
        Given(:error) { Yp::Response::MissingFieldError }
        Then { expect { transaction.send! }.to raise_error(error) }
      end

      context 'invalid card number',
          vcr: { :cassette_name => 'invalid_card_number' } do

        Given { invalid[:cardNumber] = '123' }
        Given(:error) { Yp::Response::InvalidFieldError }
        Then { expect { transaction.send! }.to raise_error(error) }
      end

    end
  end
end
