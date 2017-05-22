require 'spec_helper'

RSpec.describe GlobalReachPartners::Rate do
  let(:attributes) do
    {
      sell_currency: 'USD',
      buy_currency: 'EUR',
      amount: 1
    }
  end
  subject { described_class.new(attributes) }

  describe '#fetch' do
    it 'returns rate', vcr: { cassette_name: 'operations/get_rate' } do
      subject.fetch
      expect(subject.convert_amount).to eq(1.12)
      expect(subject.exchange_rate).to eq(1.1224)
    end
  end
end
