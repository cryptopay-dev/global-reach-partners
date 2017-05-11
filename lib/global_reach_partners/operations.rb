module GlobalReachPartners
  class << self
    def get_rate(sell_currency:, buy_currency:, amount: 1)
      message = {}
      message['objRate'] = {
        buy_amount: amount,
        sell_curr: sell_currency,
        buy_curr: buy_currency,
        value_date: Time.current.utc.iso8601
      }

      Request.new(:get_rate).call(message)
    end

    def get_currencies
      message = { error_msg: '' }

      Request.new(:get_rate).call(message)
    end

    def trade_currency(type:, sell_currency:, buy_currency:)
      raise "Type #{type} does not match." unless type.to_s.in?(%w[buy sell])

      current_message = {}
      current_message['objTradeParam'] = []
      current_message['objTradeParam']['clsBuySellCurrency'] =
        { trade_type: '100',
          settlement_date: Time.current.utc.strftime('%Y/%m/%d'),
          buying_or_selling: type,
          sell_currency: sell_currency,
          sell_currency_country: 'Russia',
          buy_currency: buy_curr,
          buy_currency_country: 'Canada',
          amount: 100.01,
          bank_ID: 1,
          payment_sending: 'a lot',
          fX_rate_matrix_guid: 'some guid',
          trade_ref: 'trade reference' }

      # is_direct_debit: false,
      # no_of_chaps: 10,
      # no_of_bacs: 10,
      # paymentcategory: 'BPEN'

      Request.new(:trade_currency).call(message)
    end
  end
end
