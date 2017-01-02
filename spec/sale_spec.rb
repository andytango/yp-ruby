require "spec_helper"

describe Yp::Sale do

  context 'has the correct action value' do
    Given(:sale) { Yp::Sale.new('signature', key: 'value') }
    Then { sale.params == { action: 'SALE', key: 'value' } }
  end

end