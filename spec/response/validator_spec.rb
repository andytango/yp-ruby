require 'spec_helper'

describe Yp::Response::Validator do
  Given(:signature) { 'Engine0Milk12Next' }

  context 'with a valid response hash' do
    Given(:params) { VALID_PARAMS }
    When(:validator) { Yp::Response::Validator.new(params, signature) }
    Then { validator.validate! }
  end

  context 'with invalid signing key' do
    Given(:params) { VALID_PARAMS.merge(signature: 'wrong') }
    Given(:error_class) { Yp::Response::InvalidSignatureError }
    When(:validator) { Yp::Response::Validator.new(params, signature) }
    Then { expect { validator.validate! }.to raise_error(error_class) }
  end

  context 'with missing signing key' do
    Given(:params) { VALID_PARAMS.reject { |k, _| k == :signature } }
    Given(:error_class) { Yp::Response::MissingSignatureError }
    When(:validator) { Yp::Response::Validator.new(params, signature) }
    Then { expect { validator.validate! }.to raise_error(error_class) }
  end
end