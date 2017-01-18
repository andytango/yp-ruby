module Yp
  class Cancel < Base

    protected

    def default_params
      { action: 'CANCEL' }
    end

  end
end