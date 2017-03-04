require 'spec_helper'

describe Yp::Response::ErrorLogger do

  Given(:transaction_logger) { spy('TransactionLogger') }
  Given(:logger) { Yp::Response::ErrorLogger.new(transaction_logger) }

  context 'no errors' do
    When { logger.log { 0 } }
    Then { expect(transaction_logger).not_to have_received(:fatal) }
    And { expect(transaction_logger).not_to have_received(:error) }
  end

  context 'error type: ' do
    context 'fatal' do
      When { expect(transaction_logger).to receive(:fatal).with(message) }

      context 'invalid signature' do
        Given(:message) { 'An invalid signature was received' }
        Given (:error) { Yp::Response::InvalidSignatureError }
        Then { expect { logger.log { raise error } }.to raise_error(error) }
      end

      context 'missing signature' do
        Given(:message) { 'Signature was not found in the response' }
        Given (:error) { Yp::Response::MissingSignatureError }
        Then { expect { logger.log { raise error } }.to raise_error(error) }
      end

      context 'missing response code' do
        Given(:message) { 'Response Code was not found in the response' }
        Given (:error) { Yp::Response::MissingResponseCodeError }
        Then { expect { logger.log { raise error } }.to raise_error(error) }
      end

      context 'missing response message' do
        Given(:message) { 'Response Message was not found in the response' }
        Given (:error) { Yp::Response::MissingResponseMessageError }
        Then { expect { logger.log { raise error } }.to raise_error(error) }
      end

    end

    context 'error:' do
      When { expect(transaction_logger).to receive(:error).with(message) }

      context 'declined error' do
        Given(:message) do
          'Transaction was declined by the acquirer' +
              ' (Yp::Response::DeclinedError)'
        end
        Given (:error) { Yp::Response::DeclinedError }
        Then { expect { logger.log { raise error } }.to raise_error(error) }
      end

      context 'missing field error' do
        Given(:message) { 'Gateway responded with missing field (foo)' }
        Given (:error) { Yp::Response::MissingFieldError.new('foo') }
        Then { expect { logger.log { raise error } }.to raise_error(error) }
      end

      context 'invalid field error' do
        Given(:message) { 'Gateway responded with invalid field (foo)' }
        Given (:error) { Yp::Response::InvalidFieldError.new('foo') }
        Then { expect { logger.log { raise error } }.to raise_error(error) }
      end

      context 'invalid field error' do
        Given(:message) { 'Gateway responded with error (foo)' }
        Given (:error) { Yp::Response::GatewayError.new('foo') }
        Then { expect { logger.log { raise error } }.to raise_error(error) }
      end

    end
  end

end