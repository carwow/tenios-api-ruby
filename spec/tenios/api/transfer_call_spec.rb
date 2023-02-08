# frozen_string_literal: true

require "securerandom"

module Tenios
  module API
    RSpec.describe Client, "#transfer_call" do
      subject(:transfer_call) { client.transfer_call }

      let(:client) { described_class.new(access_key: "test") }

      describe "#transfer" do
        subject(:transfer) { transfer_call.transfer(call_uuid: call_uuid, destination: destination) }

        let(:call_uuid) { SecureRandom.uuid }
        let(:destination) { "+441234567890" }
        let(:response) { {"success" => true} }
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

        before { allow(client).to receive(:post).and_return(response) }

        it { expect(transfer).to eq response }

        context "HTTP requests" do
          before { transfer }

          it { expect(client).to have_received(:post).with(*expected_payload) }
        end
      end
    end
  end
end
