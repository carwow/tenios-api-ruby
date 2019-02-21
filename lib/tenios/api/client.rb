require 'json'
require 'faraday'
require 'faraday_middleware'

module Tenios
  module API
    class Client
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

      def call_detail_records(start_date, page_size: 100)
        stream do |page|
          payload = payload_for_cdrs(start_date, page: page, page_size: page_size)
          http_client.post('/cdrs/retrieve', payload).body
        end
      end
      alias cdrs call_detail_records

      private

      attr_reader :access_key

      def payload_for_cdrs(start_date, page:, page_size:)
        unless %i[begin end].all? { |method| start_date.respond_to? method }
          raise TypeError, 'Expect start_date to be Range-like (respond_to methods #begin and #end)'
        end

        {
          access_key: access_key,
          start_date_from: format_datetime(start_date.begin),
          start_date_to: format_datetime(start_date.end),
          page: page,
          page_size: page_size
        }.to_json
      end

      def format_datetime(time)
        time.utc.strftime('%FT%H:%M:%S.0Z')
      end

      def stream
        Enumerator.new do |records|
          (1..Float::INFINITY).each do |page|
            res = yield page
            res['items'].each { |item| records << item }
            break if res['total_items'] <= page * res['page_size']
          end
        end.lazy
      end
    end
  end
end
