ENV['RACK_ENV'] = 'test'
require 'rack/test'

require_relative '../server.rb'

SPEC_PATH = File.expand_path(File.dirname(__FILE__))

module RSpecMixin
  include Rack::Test::Methods
  def app() MageDetect::Server end
end

RSpec.configure { |c| c.include RSpecMixin }
