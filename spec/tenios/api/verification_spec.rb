module Tenios
  module API
    RSpec.describe Client, '#verification' do
      subject(:verification) { client.verification }

      let(:client) { described_class.new(access_key: 'test') }

      describe '#create' do
        subject(:create) { verification.create(options) }

        let(:options) do
          {
            area_code: '',
            city: '',
            country: '',
            document_data: '',
            document_type: '',
            house_number: '',
            street: ''
          }
        end
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
      end
    end
  end
end
