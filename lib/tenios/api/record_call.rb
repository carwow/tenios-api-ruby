# frozen_string_literal: true

module Tenios
  module API
    class RecordCall
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def start(call_uuid:)
        client.http_client.post(
          '/record-call/start',
          access_key: client.access_key,
          call_uuid: call_uuid
        ).body
      end

      def stop(recording_uuid:, call_uuid:)
        client.http_client.post(
          '/record-call/stop',
          access_key: client.access_key,
          call_uuid: call_uuid,
          recording_uuid: recording_uuid
        ).body
      end
    end
  end
end
