module Yp
  class Sale < Base

    protected

    def default_params
      { action: 'SALE' }
    end

  end
end