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
end
