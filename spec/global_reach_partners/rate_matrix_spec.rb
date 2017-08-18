require 'spec_helper'

RSpec.describe GlobalReachPartners::RateMatrix do
  before do
    subject { described_class.new }
  end

  describe '#fetch' do
    it 'fill matrix source', vcr: { cassette_name: 'rate_matrix/fetch' } do
      subject.fetch

      expect(subject.source).to be_kind_of(Nokogiri::XML::NodeSet)
    end
  end

  describe '#get_rates' do
    let(:pair) { 'EURUSD' }

    it 'return rates for buy and sell', vcr: { cassette_name: 'rate_matrix/get_rates' } do
      subject.fetch

      expect(subject.get_rates(pair)[:buy].exchange_rate).to eq(1.1678)
      expect(subject.get_rates(pair)[:sell].exchange_rate).to eq(1.1608)
    end
  end

  describe '#ack!' do
    it 'acknowledge the GUID', vcr: { cassette_name: 'rate_matrix/ack' } do
      subject.fetch
      expect(subject.ack!).to be_truthy
    end
  end
end
