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

  xdescribe '.do_single_trade' do
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

      expect(trade.convert_amount).to eq(1.12)
      expect(trade.exchange_rate).to eq(1.1224)
    end
  end

  describe '.get_rate_matrix' do
    it 'returns rate matrix', vcr: { cassette_name: 'operations/get_rate_matrix' } do
      result = subject.get_rate_matrix

      expect(result).to be_kind_of(GlobalReachPartners::FxPlugin::RateMatrix)
    end
  end

  describe '.do_fx_trades' do
    context 'success' do
      it 'creates fx trade', vcr: { cassette_name: 'operations/do_fx_trades_success' } do
        rate_matrix = subject.get_rate_matrix
        rate_matrix.ack!

        deal = subject.do_fx_trades(
          guid: rate_matrix.guid,
          amount: 1234.5,
          buy_currency: 'EUR',
          sell_currency: 'USD',
          buying: true,
          ref: 'whatever'
        )

        expect(deal).to be_kind_of(GlobalReachPartners::FxPlugin::Deal)
        expect(deal.deal_number).to be
        expect(deal.settlement_date).to be_a Date
        expect(deal.buy_currency).to eq 'EUR'
        expect(deal.buy_amount).to eq '1234.5'.to_d
        expect(deal.sell_currency).to eq 'USD'
        expect(deal.sell_amount).to be_a BigDecimal
        expect(deal.exchange_rate).to be_a BigDecimal
        expect(deal.trade_direction).to eq 'Buy'
        expect(deal.trade_ref).to eq 'whatever'
      end
    end

    context 'failure' do
      it 'raises error', vcr: { cassette_name: 'operations/do_fx_trades_failure' } do
        rate_matrix = subject.get_rate_matrix
        rate_matrix.ack!

        expect {
          subject.do_fx_trades(
            guid: rate_matrix.guid,
            amount: 0,
            buy_currency: 'EUR',
            sell_currency: 'USD',
            buying: true
          )
        }.to raise_error GlobalReachPartners::Error
      end
    end
  end
end
