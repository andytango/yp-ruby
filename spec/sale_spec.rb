require "spec_helper"

describe Yp::Sale do

  TRANSACTION = {
      merchantID: '101381',
      type: 1,
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

  context 'has the correct action value' do
    Given(:sale) { Yp::Sale.new('signature', key: 'value') }
    Then { sale.params == { action: 'SALE', key: 'value' } }
  end

  describe 'succeeds', vcr: { :cassette_name => 'sale_success' } do
    Given(:transaction) { TRANSACTION.merge({ amount: 101 }) }
    Given(:sale) { Yp::Sale.new('Engine0Milk12Next', transaction) }
    When(:result) { sale.send }
    Then { result[:state] == 'captured' }
    And { result[:merchantID] == transaction[:merchantID] }
  end

  describe 'card referred', vcr: { :cassette_name => 'sale_card_referred' } do
    Given(:transaction) { TRANSACTION.merge({ amount: 5000 }) }
    Given(:sale) { Yp::Sale.new('Engine0Milk12Next', transaction) }
    When(:result) { sale.send }
    Then { result[:state] == 'referred' }
    And { result[:merchantID] == transaction[:merchantID] }
  end

  describe 'card declined', vcr: { :cassette_name => 'sale_card_declined' } do
    Given(:transaction) { TRANSACTION.merge({ amount: 10000 }) }
    Given(:sale) { Yp::Sale.new('Engine0Milk12Next', transaction) }
    When(:result) { sale.send }
    Then { result[:state] == 'declined' }
    And { result[:merchantID] == transaction[:merchantID] }
  end

  describe 'card declined keep',
           vcr: { :cassette_name => 'sale_card_declined_keep' } do
    Given(:transaction) { TRANSACTION.merge({ amount: 15000 }) }
    Given(:sale) { Yp::Sale.new('Engine0Milk12Next', transaction) }
    When(:result) { sale.send }
    Then { result[:state] == 'declined' }
    And { result[:merchantID] == transaction[:merchantID] }
  end

end