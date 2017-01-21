module Yp
  class TransactionLogger
    class << self

      FILTERED_KEYS = %w(cardNumber cardCVV cardExpiryMonth cardExpiryYear)

      def log_request(params)
        info 'Sending transaction', params
      end

      def log_response(params)
        info 'Response received', params
      end

      private

      def info(str, params=nil)
        Yp.logger.info("#{format_message(str)} #{format_params(params)}")
      end

      def format_message(str)
        "[YP] #{str}"
      end

      def format_params(params)
        " with params #{filter_card_params(params).to_s}"
      end

      def filter_card_params(hash)
        hash.reduce({}) { |memo, param| memo.merge(apply_filter(*param)) }
      end

      def apply_filter(k, v)
        { k => FILTERED_KEYS.include?(k.to_s) ? '[FILTERED]' : v }
      end

    end
  end
end