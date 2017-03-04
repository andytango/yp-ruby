require 'spec_helper'

describe Yp::Response::GatewayError do

  context 'create error' do
    Given (:message) { 'some message' }
    When(:error) do
      Yp::Response::GatewayError.from_response_code(code, message)
    end

    context 'with missing field code' do
      Given(:code) { '66048' }
      Then { error.instance_of? Yp::Response::MissingFieldError }
      And { error.to_s == 'request' }
    end

    context 'with invalid field code' do
      Given(:code) { '66304' }
      Then { error.instance_of? Yp::Response::InvalidFieldError }
      And { error.to_s == 'request' }
    end

    context 'with unknown field code' do
      Given(:code) { 'bananas' }
      Then { error.instance_of? Yp::Response::GatewayError }
      And { error.to_s == 'some message' }
    end
  end
end