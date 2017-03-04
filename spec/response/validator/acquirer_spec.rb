require 'spec_helper'

describe Yp::Response::Validator::Gateway do

  When(:validator) { Yp::Response::Validator::Acquirer.new(params) }

  context 'with declined params' do
    Given(:params) { { responseCode: 5 } }
    Given(:error){ Yp::Response::DeclinedError }
    Then { expect { validator.validate! }.to raise_error(error) }
  end

  context 'without declined params' do
    Given(:params) { { responseCode: 0 } }
    Given(:error){ Yp::Response::DeclinedError }
    Then { expect { validator.validate! }.to_not raise_error(error) }
  end
end