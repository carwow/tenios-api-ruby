require 'json'
require 'faraday'
require 'faraday_middleware'

module Tenios
  module API
    class Client
      attr_reader :access_key

      def initialize(access_key:)
        @access_key = access_key
      end

      def http_client
        @http_client ||= Faraday.new(url: 'https://api.tevox.com') do |c|
          c.request :json
          c.response :json
          c.response :raise_error
          c.use :gzip

          c.adapter Faraday.default_adapter
        end
      end

      class <<self
        private

        def endpoint(name, klass)
          API.autoload klass, "tenios/api/#{name}"

          class_eval <<~RUBY, __FILE__, __LINE__ + 1
            def #{name}
              @#{name} ||= #{klass}.new(self)
            end
          RUBY
        end
      end

      endpoint :call_detail_records, :CallDetailRecords
      endpoint :verification, :Verification
      endpoint :number, :Number
    end
  end
end
