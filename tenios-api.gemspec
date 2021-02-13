# frozen_string_literal: true

require_relative "lib/tenios/api/version"

Gem::Specification.new do |spec|
  spec.name = "tenios-api"
  spec.version = Tenios::API::VERSION
  spec.authors = ["carwow Developers"]
  spec.email = ["developers@carwow.co.uk"]
  spec.summary = "Tenios API Client ☎️"
  spec.description = "Ruby client for Tenios API."
  spec.homepage = "https://github.com/carwow/tenios-api-ruby"
  spec.license = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7", "< 3.1")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["homepage_uri"] = "#{spec.homepage}/blob/main/README.md"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.start_with? "spec" }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 1.3"
  spec.add_dependency "faraday_middleware", "~> 1.0"
  spec.add_dependency "zeitwerk", "~> 2.4"

  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "standard", "~> 0.12"
end
