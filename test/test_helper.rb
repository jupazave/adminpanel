ENV['RAILS_ENV'] ||= 'test'
require 'rails'
require File.expand_path('../dummy/config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/emoji' #emoji output
require 'capybara/rails'
# require 'minitest/unit' #mocha
# require 'mocha/mini_test' #mocha
require 'capybara/poltergeist'


Capybara.current_driver = :poltergeist

load Rails.root.join('db', 'schema.rb')

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class ActiveSupport::TestCase
  #fixtures live inside the dummy app
  fixtures :all

  # Add more helper methods to be used by all tests here...
end