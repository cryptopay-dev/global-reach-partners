module GlobalReachPartners
  module FxPlugin
    class Deal
      attr_reader :deal_number
      attr_reader :settlement_date
      attr_reader :buy_currency
      attr_reader :buy_amount
      attr_reader :sell_currency
      attr_reader :sell_amount
      attr_reader :exchange_rate
      attr_reader :trade_direction
      attr_reader :trade_ref
      attr_reader :raw

      def initialize(source)
        @deal_number = source.search('DealNo').text
        @settlement_date = Date.parse(source.search('SettelementDate').text)

        @buy_currency = source.search('BuyCurrency').text
        @buy_amount = string_to_decimal(source.search('BuyAmount').text)

        @sell_currency = source.search('SellCurrency').text
        @sell_amount = string_to_decimal(source.search('SellAmount').text)

        @exchange_rate = string_to_decimal(source.search('ExchangeRate').text)
        @trade_direction = source.search('TradeDirection').text
        @trade_ref = source.search('TradeRef').text

        @raw = source.to_xml
      end

      private

      # 1,201.90 => BigDecimal.new('1201.90')
      def string_to_decimal(string)
        string.delete(',').to_d
      end
    end
  end
end
