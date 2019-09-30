require 'json'
require 'faraday'
require 'faraday_middleware'

module Tenios
  module API
    autoload :CallDetailRecords, 'tenios/api/call_detail_records'

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

      def call_detail_records
        @call_detail_records ||= CallDetailRecords.new(self)
      end
      alias cdrs call_detail_records
    end
  end
end
