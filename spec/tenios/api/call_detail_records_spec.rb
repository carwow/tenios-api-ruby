module Tenios
  module API
    RSpec.describe Client, '#call_detail_records' do
      subject(:call_detail_records) { client.call_detail_records }

      let(:client) { described_class.new(access_key: 'test') }

      describe '#retrieve' do
        subject(:retrieve) { call_detail_records.retrieve(date_range) }

        let(:date_range) { Time.utc(2019, 9, 30)..Time.utc(2019, 10, 1) }
        let(:response) do
          double(body: { 'items' => [record], 'total_items' => 1, 'page_size' => 1 })
        end
        let(:record) { double }
        let(:expected_payload) do
          [
            '/cdrs/retrieve',
            {
              access_key: 'test',
              start_date_from: '2019-09-30T00:00:00.0Z',
              start_date_to: '2019-10-01T00:00:00.0Z',
              page: 1,
              page_size: 100
            }.to_json
          ]
        end

        before { allow(client.http_client).to receive(:post).and_return(response) }

        it { expect(retrieve).to be_a(Enumerator::Lazy) }
        it { expect(retrieve.count).to eq(1) }
        it { expect(retrieve.to_a).to eq([record]) }

        context 'expectations' do
          before { retrieve.count }

          it { expect(client.http_client).to have_received(:post).once }
          it { expect(client.http_client).to have_received(:post).with(*expected_payload) }
        end

        context 'empty' do
          let(:response) do
            double(body: { 'items' => [], 'total_items' => 0, 'page_size' => 0 })
          end

          it { expect(retrieve.to_a).to be_empty }
        end

        context 'multiple pages' do
          let(:response) do
            double(body: { 'items' => [record], 'total_items' => 2, 'page_size' => 1 })
          end

          it { expect(retrieve.count).to eq(2) }

          it 'makes 2 HTTP requests' do
            retrieve.count

            expect(client.http_client).to have_received(:post).twice
          end

          it 'makes 1 HTTP request' do
            retrieve.first

            expect(client.http_client).to have_received(:post).once
          end
        end

        context 'expects date range' do
          let(:date_range) { nil }

          it 'raises error' do
            expect { retrieve.to_a }.to raise_error TypeError, <<~ERR.strip
              Expect date_range to be Range-like (respond_to methods #begin and #end), but was: #{date_range.class}
            ERR
          end
        end
      end
    end
  end
end
