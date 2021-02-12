# frozen_string_literal: true

module Tenios
  module API
    class Number
      attr_reader :client

      def initialize(client)
        @client = client
      end

      NUMBER_TYPES = [
        GEOGRAPHICAL = "GEOGRAPHICAL"
      ].freeze

      def order(verification_id:, number_type: GEOGRAPHICAL, **options)
        payload = order_payload(verification_id: verification_id, number_type: number_type, **options)
        client.post("/number/order", **payload)
      end

      def cancel(phone_number:)
        client.post("/number/cancel", phone_number: phone_number)
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
        options.slice(*ORDER_OPTIONS)
      end
    end
  end
end
