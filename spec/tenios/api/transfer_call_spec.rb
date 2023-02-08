# frozen_string_literal: true

require "securerandom"

module Tenios
  module API
    RSpec.describe Client, "#transfer_call" do
      subject(:transfer_call) { client.transfer_call(call_uuid: call_uuid, destination: destination) }
      let(:client) { described_class.new(access_key: "test") }
      let(:call_uuid) { SecureRandom.uuid }
      let(:destination) { "+441234567890" }
      let(:response) { {"success" => true} }

      before { allow(client).to receive(:post).and_return(response) }

      it { expect(transfer_call).to eq response }

      context "HTTP requests" do
        before { transfer_call }
        let(:expected_payload) do
          [
            "/transfer-call",
            {
              call_uuid: call_uuid,
              destination_type: Tenios::API::TransferCall::EXTERNAL_NUMBER,
              destination: destination
            }
          ]
        end

        it { expect(client).to have_received(:post).with(*expected_payload) }
      end
    end
  end
end
