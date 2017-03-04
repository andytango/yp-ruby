require 'version'
require 'rest-client'
require 'digest'
require 'erb'
require 'cgi'
require 'logger'
require 'nil_logger'

require 'base'

require 'sale'
require 'verify'
require 'preauth'
require 'factory'

module Yp
  URL = 'https://gateway.yorkshirepayments.com/direct/'

  class << self
    attr_accessor :logger

    def data_files_path
      File.join(File.dirname(File.expand_path(__FILE__)), '../data')
    end
  end

  self.logger = NilLogger.new
end
