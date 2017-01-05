# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pure_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "pure_validator"
  spec.version       = PureValidator::VERSION
  spec.authors       = ["Albert Gazizov"]
  spec.email         = ["deeper4k@gmail.com"]
  spec.description   = %q{Object validation library}
  spec.summary       = %q{Moves validation logic to validators}
  spec.homepage      = "http://github.com/ddd-ruby/pure_validator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency             "i18n"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "codecov"
  spec.add_development_dependency "byebug"
end
