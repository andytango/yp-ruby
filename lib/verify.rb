module Yp
  class Verify < Base

    protected

    def default_params
      { action: 'VERIFY' }
    end

    def action_params
      { amount: 0 }
    end

  end
end