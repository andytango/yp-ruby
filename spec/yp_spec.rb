require "spec_helper"

describe Yp do

  context 'has a nil logger by default' do
    Then { Yp.logger.class == Yp::NilLogger }
  end

  context 'can set logger' do
    Given(:logger) { Logger.new(STDOUT) }
    When { Yp.logger = logger }
    Then { Yp.logger == logger }
  end

end