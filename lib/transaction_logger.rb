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

      def info(str, params=nil)
        Yp.logger.info(format(str, params))
      end

      def error(str)
        Yp.logger.error(format_message(str))
      end

      def fatal(str)
        Yp.logger.fatal(format_message(str))
      end

      private

      def format(str, params)
        "#{format_message(str)} #{format_params(params)}"
      end

      def format_message(str)
        "[YP] #{str}"
      end

      def format_params(params)
        " with params #{filter_card_params(params).to_s}" unless params.nil?
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