require 'spec_helper'

RSpec.describe GlobalReachPartners::Operations do
  subject { GlobalReachPartners }

  describe '.get_currencies' do
    it 'returns array of currencies', vcr: { cassette_name: 'operations/get_currencies' } do
      expect(subject.get_currencies.first).to be_kind_of(GlobalReachPartners::Currency)
    end
  end

  describe '.get_rate' do
    let(:parameters) do
      {
        sell_currency: 'USD',
        buy_currency: 'EUR',
        amount: 1
      }
    end

    it 'returns rate', vcr: { cassette_name: 'operations/get_rate' } do
      rate = subject.get_rate(parameters)

      expect(rate).to be_kind_of(GlobalReachPartners::Rate)
      expect(rate.convert_amount).to eq(1.12)
      expect(rate.exchange_rate).to eq(1.1224)
    end
  end

  describe '.do_single_trade' do
    let(:parameters) do
      {
        type: 'buy',
        sell_currency: 'EUR',
        buy_currency: 'USD',
        amount: 12
      }
    end

    it 'creates trade', vcr: { cassette_name: 'operations/do_single_trade' } do
      trade = subject.do_single_trade(parameters)

      require 'pry'; binding.pry
      #expect(trade).to be_kind_of(GlobalReachPartners::Rate)
      expect(trade.convert_amount).to eq(1.12)
      expect(trade.exchange_rate).to eq(1.1224)
    end
  end
end
