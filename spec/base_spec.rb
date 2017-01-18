require "spec_helper"

describe Yp::Base do

  TRANSACTION = {
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

  SERIALIZED_TRANSACTION =
      'action=SALE&amount=1001&cardCVV=083&cardExpiryMonth=12&cardExpiryYear' +
      '=15&cardNumber=4012001037141112&countryCode=826&currencyCode=826&cust' +
      'omerAddress=16+Test+Street&customerEmail=support%40yorkshirepayments.' +
      'com&customerName=Yorkshire+Payments&customerPostCode=TE15+5ST&merchan' +
      'tID=101381&orderRef=Test+purchase&type=1'

  context 'version number' do
    Then { !Yp::VERSION.nil? }
  end

  describe 'serialize_params' do
    context 'should return an empty string if no params' do
      Then { Yp::Base.serialize_params({}) == '' }
    end

    context 'url-encoded string for a single param, sorted' do
      Given(:params) { { key: 'value 123' } }
      When(:result)  { Yp::Base.serialize_params(params) }
      Then { result == 'key=value+123' }
    end

    context 'multiple properties, sorted alphabetically by key' do
      Given(:params) { { key: 'value 123', a_key: 'value 456' } }
      When(:result)  { Yp::Base.serialize_params(params) }
      Then { result == 'a_key=value+456&key=value+123' }
    end

    context 'transaction' do
      When(:result) { Yp::Base.serialize_params(TRANSACTION) }
      Then { result == SERIALIZED_TRANSACTION }
    end
  end

  describe 'sha-512 digest' do
    context 'empty string' do
      When(:result) { Yp::Base.digest('') }
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
      Given(:transaction) { Yp::Base.new('DontTellAnyone', TRANSACTION) }
      When(:result) { transaction.create_signing_hash }
      Then do
        result ==
            '73b396c7e718ea5fb477f8c14ab04303d067e922e004ed93db9e5827f25b99c' +
            'fbbf1241cc85e125ed04987f96b628fabcb702b67e113114ad978b34e0cacfa' +
            '37'
      end
    end
  end

  describe 'send', vcr: { :cassette_name => 'example_transaction_docs' } do
    Given(:transaction) { Yp::Base.new('Engine0Milk12Next', TRANSACTION) }
    When(:result) { transaction.send }
    Then { result[:state] == 'captured' }
    And { result[:merchantID] == TRANSACTION[:merchantID] }
  end
end
