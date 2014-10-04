# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nulab_backlog/version'

Gem::Specification.new do |spec|
  spec.name          = "nulab_backlog"
  spec.version       = NulabBacklog::VERSION
  spec.authors       = ["KitaitiMakoto"]
  spec.email         = ["KitaitiMakoto@gmail.com"]
  spec.summary       = %q{Nulab's Backlog API client library and tools.}
  spec.description   = %q{Nulab's Backlog API v2 client library and tools.}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.1.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "activemodel"
  spec.add_runtime_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubygems-tasks"
  spec.add_development_dependency "pry"
end
