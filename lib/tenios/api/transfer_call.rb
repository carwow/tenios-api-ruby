# frozen_string_literal: true

module Tenios
  module API
    class TransferCall
      EXTERNAL_NUMBER = "EXTERNALNUMBER"
      SIP_USER = "SIP_USER"
      SIP_TRUNK = "SIP_TRUNK"

      DESTINATION_TYPES = [
        EXTERNAL_NUMBER,
        SIP_USER,
        SIP_TRUNK
      ].freeze

      attr_reader :client

      def initialize(client)
        @client = client
      end

      def transfer_call(call_uuid:, destination:, destination_type: EXTERNAL_NUMBER)
        raise "destination_type must be one of #{DESTINATION_TYPES}" unless DESTINATION_TYPES.include?(destination_type)

        client.post(
          "/transfer-call",
          call_uuid: call_uuid,
          destination_type: destination_type,
          destination: destination
        )
      end
    end
  end
end
