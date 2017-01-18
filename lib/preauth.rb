module Yp
  class Preauth < Base

    protected

    def default_params
      { action: 'PREAUTH' }
    end

  end
end