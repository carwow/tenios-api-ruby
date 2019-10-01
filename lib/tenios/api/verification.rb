module Tenios
  module API
    class Verification
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def create(options)
        payload = build_payload(options)
        client.http_client.post('/verification/create', payload).body
      end

      private

      def build_payload(options)
        {
          access_key: client.access_key,
          area_code: options.fetch(:area_code),
          city: options.fetch(:city),
          country: options.fetch(:country),
          document_data: options.fetch(:document_data),
          document_type: options.fetch(:document_type),
          house_number: options.fetch(:house_number),
          street: options.fetch(:street)
        }.to_json
      end
    end
  end
end
