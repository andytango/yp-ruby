require 'spec_helper'

describe Yp::Response::Validator::Gateway do

  Given(:validator) { Yp::Response::Validator::Gateway.new(params) }

  context 'with missing response code' do
    Given(:params) { { responseMessage: 'foo' } }
    Given(:error) { Yp::Response::Validator::MissingResponseCodeError }
    Then { expect { validator.validate! }.to raise_error(error) }
  end

  context 'with missing response message and request error response code' do
    Given(:params) { { responseStatus: '6' } }
    Given(:error) { Yp::Response::Validator::MissingResponseMessageError }
    Then { expect { validator.validate! }.to raise_error(error) }
  end
end