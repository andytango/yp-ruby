module Yp
  class RefundSale < Base

    protected

    def default_params
      { action: 'REFUND_SALE' }
    end

  end
end