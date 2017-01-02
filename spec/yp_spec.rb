require "spec_helper"

describe Yp::Base do

  TRANSACTION = {
      merchantID: '101380',
      action: 'SALE',
      type: '1',
      currencyCode: '826',
      countryCode: '826',
      amount: '2691',
      transactionUnique: '55f025addd3c2',
      orderRef: 'Signature Test',
      cardNumber: '4929 4212 3460 0821',
      cardExpiryDate: '1213'
  }

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
      Then do
        result ==
            'action=SALE&amount=2691&cardExpiryDate=1213&cardNumber=4929+42' +
            '12+3460+0821&countryCode=826&currencyCode=826&merchantID=10138' +
            '0&orderRef=Signature+Test&transactionUnique=55f025addd3c2&type' +
            '=1'
      end
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
            '4df549856fb4e35539c024a45a066392e13b74a8f3c724884f17dd69419f29d' +
            'bb3bcde5ef467f14e80778b605893d27e84527bfad44de0ea429db423468e5e' +
            'e8'
      end
    end
  end
end
