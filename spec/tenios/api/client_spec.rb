# frozen_string_literal: true

module Tenios
  module API
    RSpec.describe Client do
      subject(:client) { described_class.new(access_key: "test") }

      describe "#call_detail_records" do
        it { expect(client.call_detail_records).to be_a(CallDetailRecords) }
      end

      describe "#verification" do
        it { expect(client.verification).to be_a(Verification) }
      end

      describe "#number" do
        it { expect(client.number).to be_a(Number) }
      end

      describe "#record_call" do
        it { expect(client.record_call).to be_a(RecordCall) }
      end

      describe "#post" do
        let(:http_client) { instance_double(Faraday::Connection, post: response) }
        let(:response) { instance_double(Faraday::Response, body: "body") }

        before { allow(Faraday).to receive(:new).and_return(http_client) }

        it "returns response body and calls http_client#post with access_key" do
          expect(client.post("path", {param: "param"})).to eq("body")

          expect(http_client).to have_received(:post)
            .with("path", {param: "param", access_key: "test"})
        end
      end
    end
  end
end
