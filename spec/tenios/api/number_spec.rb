# frozen_string_literal: true

module Tenios
  module API
    RSpec.describe Client, '#number' do
      subject(:number) { client.number }

      let(:client) { described_class.new(access_key: 'test') }

      describe '#order' do
        subject(:order) { number.order(options) }

        let(:options) { { verification_id: 'CODE' } }
        let(:expected_payload) do
          [
            '/number/order',
            { access_key: 'test', number_type: Number::GEOGRAPHICAL }
              .merge(options)
              .to_json
          ]
        end
        let(:response) { double(body: response_body) }
        let(:response_body) { { 'order_id' => '123' } }

        before { allow(client.http_client).to receive(:post).and_return(response) }

        it { expect(order).to eq response_body }

        context 'HTTP requests' do
          before { order }

          it { expect(client.http_client).to have_received(:post).with(*expected_payload) }

          context 'optional options' do
            let(:options) do
              {
                link_to_number: '+44123456789',
                number_type: 'NATIONAL',
                push_secret: 'secret',
                push_url: 'https://www.example.com/tenios',
                verification_id: 'CODE',
                ignored: 'ignored'
              }
            end
            let(:expected_payload) do
              [
                '/number/order',
                { access_key: 'test' }
                .merge(options.reject { |name| name == :ignored })
                .to_json
              ]
            end

            it { expect(client.http_client).to have_received(:post).with(*expected_payload) }
          end
        end
      end
    end
  end
end
