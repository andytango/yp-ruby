require "spec_helper"

describe Yp::TransactionRequest do

  TRANSACTION_FIELDS = {
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

  it 'has a version number' do
    expect(Yp::VERSION).not_to be nil
  end

  describe 'serialize_params' do
    it 'should return an empty string if no params' do
      expect(Yp::TransactionRequest.serialize_params({})).to eq('')
    end

    it 'should return a url-encoded string for a multiple properties, sorted' +
        ' alphabetically by key' do

      expect(Yp::TransactionRequest.serialize_params({ key: 'value 123' }))
          .to eq('key=value+123')
    end

    it 'should return a url-encoded string for a multiple properties, sorted' +
        ' alphabetically by key' do

      expect(Yp::TransactionRequest.serialize_params({
          key: 'value 123', a_key: 'value 456'
      })).to eq('a_key=value+456&key=value+123')

    end

    it 'should return a url-encoded string for a example transaction, sorted' +
      ' alphabetically by key' do

      expect(Yp::TransactionRequest.serialize_params(TRANSACTION_FIELDS))
          .to eq('action=SALE&amount=2691&cardExpiryDate=1213&cardNumber=492' +
              '9+4212+3460+0821&countryCode=826&currencyCode=826&merchantID=' +
              '101380&orderRef=Signature+Test&transactionUnique=55f025addd3c' +
              '2&type=1')

    end
  end

  describe 'digest' do
    it 'should return the SHA-512 of an empty string' do
      expect(Yp::TransactionRequest.digest(''))
          .to eq('cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d3' +
              '6ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327' +
              'af927da3e')
    end
  end

  describe 'create_signing_hash' do

    it 'should return a hash of the serialized keys with the signature' +
        ' appended' do

      expect(Yp::TransactionRequest.new(
          'signature',
          key: 'value 123',
          a_key: 'value 456'
      ).create_signing_hash)
          .to eq('0adba88d7eaff7ecf7e04a891823edb5684b290f66d813dfdff09ba9f2' +
              '48897f01c5bde63fdf705e7dee69238f65260dd1de73d4ac1c31dafd4150a' +
              '543c7e987')

      expect(Yp::TransactionRequest.new('DontTellAnyone', TRANSACTION_FIELDS)
                 .create_signing_hash)
          .to eq('4df549856fb4e35539c024a45a066392e13b74a8f3c724884f17dd69419'+
              'f29dbb3bcde5ef467f14e80778b605893d27e84527bfad44de0ea429db4234'+
              '68e5ee8')

    end
  end
end
