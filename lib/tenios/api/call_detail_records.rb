module Tenios
  module API
    class CallDetailRecords
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def retrieve(date_range, page_size: 100)
        stream do |page|
          payload = build_payload(date_range, page: page, page_size: page_size)
          client.http_client.post('/cdrs/retrieve', payload).body
        end
      end

      private

      def build_payload(date_range, page:, page_size:)
        expect_date_range! date_range

        {
          access_key: client.access_key,
          start_date_from: format_datetime(date_range.begin),
          start_date_to: format_datetime(date_range.end),
          page: page,
          page_size: page_size
        }.to_json
      end

      def expect_date_range!(date_range)
        return if %i[begin end].all? { |method| date_range.respond_to? method }

        raise TypeError, <<~ERR.strip
          Expect date_range to be Range-like (respond_to methods #begin and #end), but was: #{date_range.class}
        ERR
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
