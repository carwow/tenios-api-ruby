module Tenios
  module API
    RSpec.describe Client do
      subject(:client) { described_class.new(access_key: 'test') }

      describe '#call_detail_records' do
        subject(:call_detail_records) { client.call_detail_records }

        it { expect(call_detail_records).to be_a(CallDetailRecords) }
      end

      describe '#verification' do
        subject(:verification) { client.verification }

        it { expect(verification).to be_a(Verification) }
      end
    end
  end
end
