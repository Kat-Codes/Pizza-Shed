require 'capybara'
require 'rspec'
require 'cucumber'
require 'simplecov'
require 'capybara/dsl'
require 'capybara/rspec'

SimpleCov.start do
  add_filter 'features/'
end

require_relative '../../site'

ENV['RACK_ENV'] = 'test'

Capybara.app = Sinatra::Application

class Sinatra::ApplicationWorld
  include RSpec::Expectations
  include RSpec::Matchers
  include Capybara::DSL
end

World do
	Sinatra::ApplicationWorld.new  
end


