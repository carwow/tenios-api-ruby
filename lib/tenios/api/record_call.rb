# frozen_string_literal: true

module Tenios
  module API
    class RecordCall
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def start(call_uuid:)
        client.post("/record-call/start", call_uuid: call_uuid)
      end

      def stop(recording_uuid:, call_uuid:)
        client.post("/record-call/stop", call_uuid: call_uuid, recording_uuid: recording_uuid)
      end
    end
  end
end
