class TestAmounts
  class << self

    def accepted
      rand(101..4999)
    end

    def referred
      rand(5000..9999)
    end

    def declined
      rand(10000..14999)
    end

    def declined_keep
      rand(15000)
    end

    private

    def rand(max)
      random.rand(max)
    end

    def random
      @random ||= Random.new
    end
  end
end

VALID_PARAMS = {
  merchantID: '101381',
  threeDSEnabled: 'N',
  threeDSCheckPref: 'not checked,authenticated',
  avscv2CheckEnabled: 'Y',
  cv2CheckPref: 'matched',
  addressCheckPref: 'not known,not checked,matched,not matched,partially matched',
  postcodeCheckPref: 'not known,not checked,matched,not matched,partially matched',
  cardCVVMandatory: 'Y',
  notifyEmail: 'lewis.parry@yorkshirepayments.com',
  customerReceiptsRequired: 'Y',
  eReceiptsEnabled: 'N',
  eReceiptsStoreID: '1',
  action: 'SALE',
  type: '1',
  countryCode: '826',
  currencyCode: '826',
  amount: '1001',
  cardExpiryMonth: '12',
  cardExpiryYear: '15',
  customerName: 'Yorkshire Payments',
  customerEmail: 'support@yorkshirepayments.com',
  customerAddress: '16 Test Street',
  customerPostCode: 'TE15 5ST',
  orderRef: 'Test purchase',
  customerPostcode: 'TE15 5ST',
  requestID: '586a5011912f7',
  responseCode: '0',
  responseMessage: 'AUTHCODE:627462',
  state: 'captured',
  requestMerchantID: '101381',
  processMerchantID: '101381',
  xref: '17010213KB05QH21HG65DMG',
  paymentMethod: 'card',
  cardExpiryDate: '1215',
  authorisationCode: '627462',
  transactionID: '13839380',
  responseStatus: '0',
  timestamp: '2017-01-02 13:05:21',
  amountReceived: '1001',
  avscv2ResponseCode: '222100',
  avscv2ResponseMessage: 'ALL MATCH',
  avscv2AuthEntity: 'merchant host',
  cv2Check: 'matched',
  addressCheck: 'matched',
  postcodeCheck: 'matched',
  cardNumberMask: '401200******1112',
  cardType: 'Visa Credit',
  cardTypeCode: 'VC',
  cardScheme: 'Visa ',
  cardSchemeCode: 'VC',
  cardIssuer: 'Unknown',
  cardIssuerCountry: 'Unknown',
  cardIssuerCountryCode: 'XXX',
  notifyEmailResponseCode: '0',
  notifyEmailResponseMessage: 'Email successfully queued',
  customerReceiptsResponseCode: '0',
  customerReceiptsResponseMessage: 'Email successfully queued',
  vcsResponseCode: '0',
  vcsResponseMessage: 'Success - no velocity check rules applied',
  currencyExponent: '2',
  signature: 'd884fb5bf968dd544ccb3791784f07246af63bfccbf63f4dad11494fecf48ea731b5ddf18189370eeb1e1344097f13c8f1200bec22a162af7ddffd19ad1312ed'
}