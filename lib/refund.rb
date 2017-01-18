module Yp
  class Refund < Base

    protected

    def default_params
      { action: 'REFUND' }
    end

  end
end