module Yp
  class Response
    class ErrorLogger
      extend Forwardable

      def_delegators :@logger, :fatal, :error

      def initialize(logger)
        @logger = logger
      end

      def log
        begin
          yield
        rescue InvalidSignatureError => e
          log_fatal 'An invalid signature was received', e
        rescue MissingSignatureError => e
          log_not_found 'Signature', e
        rescue MissingResponseCodeError => e
          log_not_found 'Response Code', e
        rescue MissingResponseMessageError => e
          log_not_found 'Response Message', e
        rescue DeclinedError => e
          log_error 'Transaction was declined by the acquirer', e
        rescue MissingFieldError => e
          log_error 'Gateway responded with missing field', e
        rescue InvalidFieldError => e
          log_error 'Gateway responded with invalid field', e
        rescue GatewayError => e
          log_error 'Gateway responded with error', e
        end
      end

      private

      def log_not_found(thing, e)
        log_fatal("#{thing} was not found in the response", e)
      end

      def log_fatal(str, e)
        fatal(str)
        raise e
      end

      def log_error(str, e)
        error("#{str} (#{e})")
        raise e
      end


    end
  end
end