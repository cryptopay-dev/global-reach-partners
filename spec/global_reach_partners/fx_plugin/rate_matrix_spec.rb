require 'spec_helper'

RSpec.describe GlobalReachPartners::FxPlugin::RateMatrix do
  subject(:matrix) { described_class.fetch }

  describe '.fetch' do
    it 'returns filled matrix', vcr: { cassette_name: 'fx_plugin/rate_matrix/fetch' } do
      matrix = described_class.fetch

      expect(matrix).to be_a described_class
      expect(matrix.guid).to be
    end
  end

  describe '#get_rates' do
    let(:pair) { 'EURUSD' }

    it 'return rates for buy and sell', vcr: { cassette_name: 'fx_plugin/rate_matrix/get_rates' } do
      expect(matrix.get_rates(pair)[:buy].exchange_rate).to eq(1.1678)
      expect(matrix.get_rates(pair)[:sell].exchange_rate).to eq(1.1608)
    end
  end

  describe '#ack!' do
    it 'acknowledge the GUID', vcr: { cassette_name: 'fx_plugin/rate_matrix/ack' } do
      expect(matrix.ack!).to be_truthy
    end
  end
end
