require 'bundler'
Bundler.require(:default, :test)

require_relative '../lib/bors'

RSpec.configure do |config|
	config.order = "random"
end