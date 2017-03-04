require "spec_helper"

describe Yp::Preauth do

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

  context 'has the correct action and type value' do
    Given(:preauth) { Yp::Preauth.new('signature', key: 'value') }
    Then { preauth.params == { action: 'PREAUTH', type: 1, key: 'value' } }
  end

  describe 'succeeds', vcr: { :cassette_name => 'preauth_success' } do
    Given(:transaction) { params.merge({ amount: 101 }) }
    Given(:preauth) { Yp::Preauth.new('Engine0Milk12Next', transaction) }
    When(:result) { preauth.send! }
    Then { result[:state] == 'reversed' }
    And { result[:merchantID] == transaction[:merchantID] }
  end

  describe 'card referred',
           vcr: { :cassette_name => 'preauth_card_referred' } do

    Given(:transaction) { params.merge({ amount: 5000 }) }
    Given(:preauth) { Yp::Preauth.new('Engine0Milk12Next', transaction) }
    When(:result) { preauth.send! }
    Then { result[:state] == 'referred' }
    And { result[:merchantID] == transaction[:merchantID] }
  end

  describe 'card declined',
           vcr: { :cassette_name => 'preauth_card_declined' } do

    Given(:transaction) { params.merge({ amount: 10000 }) }
    Given(:preauth) { Yp::Preauth.new('Engine0Milk12Next', transaction) }
    When(:result) { preauth.send! }
    Then { result[:state] == 'declined' }
    And { result[:merchantID] == transaction[:merchantID] }
  end

  describe 'card declined keep',
           vcr: { :cassette_name => 'preauth_card_declined_keep' } do

    Given(:transaction) { params.merge({ amount: 15000 }) }
    Given(:preauth) { Yp::Preauth.new('Engine0Milk12Next', transaction) }
    When(:result) { preauth.send! }
    Then { result[:state] == 'declined' }
    And { result[:merchantID] == transaction[:merchantID] }
  end

end