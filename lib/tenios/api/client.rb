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

      def call_detail_records
        CallDetailRecords.new(self)
      end

      def verification
        Verification.new(self)
      end

      def number
        Number.new(self)
      end

      def record_call
        RecordCall.new(self)
      end

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
