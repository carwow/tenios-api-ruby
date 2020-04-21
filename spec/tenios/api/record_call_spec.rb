# frozen_string_literal: true

require 'securerandom'

module Tenios
  module API
    RSpec.describe Client, '#record_call' do
      subject(:record_call) { client.record_call }

      let(:client) { described_class.new(access_key: 'test') }

      describe '#start' do
        subject(:start) { record_call.start(call_uuid: call_uuid) }

        let(:call_uuid) { SecureRandom.uuid }
        let(:response_body) { { 'recording_uuid' => SecureRandom.uuid } }
        let(:response) { double(body: response_body) }
        let(:expected_payload) do
          [
            '/record-call/start',
            {
              call_uuid: call_uuid,
              access_key: 'test'
            }
          ]
        end

        before { allow(client.http_client).to receive(:post).and_return(response) }

        it { expect(start).to eq response_body }

        context 'HTTP requests' do
          before { start }

          it { expect(client.http_client).to have_received(:post).with(*expected_payload) }
        end
      end

      describe '#stop' do
        subject(:stop) { record_call.stop(call_uuid: call_uuid, recording_uuid: recording_uuid) }

        let(:call_uuid) { SecureRandom.uuid }
        let(:recording_uuid) { SecureRandom.uuid }
        let(:response_body) { { 'success' => 'true' } }
        let(:response) { double(body: response_body) }
        let(:expected_payload) do
          [
            '/record-call/stop',
            {
              call_uuid: call_uuid,
              recording_uuid: recording_uuid,
              access_key: 'test'
            }
          ]
        end

        before { allow(client.http_client).to receive(:post).and_return(response) }

        it { expect(stop).to eq response_body }

        context 'HTTP requests' do
          before { stop }

          it { expect(client.http_client).to have_received(:post).with(*expected_payload) }
        end
      end
    end
  end
end
