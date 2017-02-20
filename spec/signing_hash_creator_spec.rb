require "spec_helper"

describe Yp::Sale do
  Given(:params) do
    {
        merchantID: '101381',
        action: 'SALE',
        type: 1,
        countryCode: 826,
        currencyCode:  826,
        amount:  1001,
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

  describe 'serialize_params' do
    context 'should return an empty string if no params' do
      Then { Yp::SigningHashCreator.serialize_params({}) == '' }
    end

    context 'url-encoded string for a single param, sorted' do
      Given(:params) { { key: 'value 123' } }
      When(:result)  { Yp::SigningHashCreator.serialize_params(params) }
      Then { result == 'key=value+123' }
    end

    context 'multiple properties, sorted alphabetically by key' do
      Given(:params) { { key: 'value 123', a_key: 'value 456' } }
      When(:result)  { Yp::SigningHashCreator.serialize_params(params) }
      Then { result == 'a_key=value+456&key=value+123' }
    end

    context 'transaction' do
      When(:result) { Yp::SigningHashCreator.serialize_params(params) }
      Then { result == serialized_transaction }
    end
  end

  describe 'sha-512 digest' do
    context 'empty string' do
      When(:result) { Yp::SigningHashCreator.digest('') }
      Then do
        result ==
            'cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9c' +
            'e47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da' +
            '3e'
      end
    end
  end

  describe 'create_signing_hash' do

    context 'transaction with signature' do
      Given(:creator) { Yp::SigningHashCreator.new(params, 'DontTellAnyone') }
      When(:result) { creator.create }
      Then do
        result ==
            '8876a6eeb2066d7e487d8e807b4ab0151f3022b3c8c69172fbabab0e150251d' +
            '604aaf3ca795545726d4fd40d1d839fc56d682b8ab2159acabac01a14348fc2' +
            'c8'
      end
    end
  end

end