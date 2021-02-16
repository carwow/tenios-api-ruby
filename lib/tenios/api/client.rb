# frozen_string_literal: true

require "json"
require "faraday"
require "faraday_middleware"

module Tenios
  module API
    class Client
      URL = "https://api.tenios.com"

      def initialize(access_key:, url: URL)
        @access_key = access_key
        @http_client = build_http_client(url)
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
      endpoint :record_call, :RecordCall

      # @api private
      def post(path, **payload)
        @http_client.post(path, payload.merge(access_key: @access_key)).body
      end

      private

      def build_http_client(url)
        Faraday.new(url: url) { |c|
          c.request :json
          c.response :json
          c.response :raise_error
          c.use :gzip

          c.adapter Faraday.default_adapter
        }
      end
    end
  end
end
