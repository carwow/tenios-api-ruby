module Tenios
  module API
    RSpec.describe Client, '#verification' do
      subject(:verification) { client.verification }

      let(:client) { described_class.new(access_key: 'test') }

      describe '#create' do
        subject(:create) { verification.create(options) }

        let(:valid_options) do
          {
            area_code: '20',
            city: 'London',
            country: 'UK',
            document_data: '%PDF-',
            document_type: Verification::DOCUMENT_TYPES.sample,
            house_number: '10',
            street: 'Downing Street'
          }
        end
        let(:options) { valid_options }
        let(:expected_payload) { ['/verification/create', { access_key: 'test' }.merge(options).to_json] }
        let(:response) { double(body: response_body) }
        let(:response_body) { { 'verification_id' => 'CODE' } }

        before { allow(client.http_client).to receive(:post).and_return(response) }

        it { expect(create).to eq response_body }

        context 'HTTP requests' do
          before { create }

          it { expect(client.http_client).to have_received(:post).with(*expected_payload) }
        end

        context 'requires all options' do
          let(:options) { { country: '' } }

          it { expect { create }.to raise_error KeyError }
        end

        context 'validates document_type' do
          let(:options) { valid_options.merge(document_type: 'invalid') }

          it { expect { create }.to raise_error ArgumentError, 'invalid document_type: invalid' }
        end
      end
    end
  end
end
