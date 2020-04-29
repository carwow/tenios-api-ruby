# frozen_string_literal: true

module Tenios
  module API
    class Number
      attr_reader :client

      def initialize(client)
        @client = client
      end

      NUMBER_TYPES = [
        GEOGRAPHICAL = 'GEOGRAPHICAL'
      ].freeze

      def order(verification_id:, number_type: GEOGRAPHICAL, **options)
        payload = order_payload(verification_id: verification_id, number_type: number_type, **options)
        client.http_client.post('/number/order', payload).body
      end

      def cancel(phone_number:)
        payload = { access_key: client.access_key, phone_number: phone_number }
        client.http_client.post('/number/cancel', payload).body
      end

      private

      ORDER_OPTIONS = %i[
        link_to_number
        number_type
        push_secret
        push_url
        verification_id
      ].freeze
      private_constant :ORDER_OPTIONS

      def order_payload(**options)
        options
          .slice(*ORDER_OPTIONS)
          .merge(access_key: client.access_key)
      end
    end
  end
end
