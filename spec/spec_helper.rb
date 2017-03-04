$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "yp"
require "vcr"
require "rspec/given"
require "webmock/rspec"
require "yp_helper"

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end