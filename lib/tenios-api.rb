# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.for_gem.tap do |loader|
  loader.ignore "#{__dir__}/tenios-api.rb"
  loader.inflector.inflect "api" => "API"
  loader.setup
end
