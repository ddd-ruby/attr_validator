require 'rubygems'
require 'bundler/setup'

require "byebug"
require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/.direnv/"
  add_filter "/core_extensions/class_attribute" # copy from ActiveSupport
  add_filter "/core_extensions/humanize" # copy from ActiveSupport
  add_filter "/attr_validator/concern" # copy from ActiveSupport
end
if ENV['CI']=='true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
require 'attr_validator'

RSpec.configure do |config|
  config.color_enabled = true
end
