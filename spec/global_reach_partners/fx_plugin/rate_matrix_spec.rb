require 'spec_helper'

RSpec.describe GlobalReachPartners::FxPlugin::RateMatrix do
  subject(:matrix) { GlobalReachPartners::FxPlugin::Operations::GetRateMatrix.call }

  describe '#guid' do
    it 'returns guid', vcr: { cassette_name: 'fx_plugin/rate_matrix/guid' } do
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
