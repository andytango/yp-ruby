module Yp
  class Response
    class Validator
      class Acquirer

        def initialize(params)
          @params = params
        end

        def validate!
          !declined? || (raise DeclinedError)
        end

        private

        def declined?
          response_code == 4 || response_code == 5
        end

        def response_code
          @response_code ||= @params[:responseCode].to_i
        end

      end
    end
  end
end