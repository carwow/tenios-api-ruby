module Tenios
  module API
    class Number
      attr_reader :client

      def initialize(client)
        @client = client
      end

      NUMBER_TYPES = %w[GEOGRAPHICAL].freeze

      def order(verification_id:, number_type: NUMBER_TYPES.first, **options)
        payload = build_payload(verification_id: verification_id, number_type: number_type, **options)
        client.http_client.post('/number/order', payload).body
      end

      private

      OPTIONS = %i[
        link_to_number
        number_type
        push_secret
        push_url
        verification_id
      ].freeze
      private_constant :OPTIONS

      def build_payload(options)
        { access_key: client.access_key }
          .merge(options.slice(*OPTIONS))
          .to_json
      end
    end
  end
end
