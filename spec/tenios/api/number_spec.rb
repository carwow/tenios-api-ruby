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
            options
              .merge(access_key: 'test', number_type: Number::GEOGRAPHICAL)
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
                options
                  .merge(access_key: 'test')
                  .reject { |name| name == :ignored }
              ]
            end

            it { expect(client.http_client).to have_received(:post).with(*expected_payload) }
          end
        end
      end

      describe '#cancel' do
        subject(:cancel) { number.cancel(phone_number: '+49888888') }

        let(:expected_payload) do
          ['/number/cancel', { access_key: 'test', phone_number: '+49888888' }]
        end
        let(:response) { double(body: response_body) }
        let(:response_body) { { 'cancellation_date' => '2019-01-01' } }

        before { allow(client.http_client).to receive(:post).and_return(response) }

        it { expect(cancel).to eq response_body }

        context 'HTTP requests' do
          before { cancel }

          it { expect(client.http_client).to have_received(:post).with(*expected_payload) }
        end
      end
    end
  end
end
