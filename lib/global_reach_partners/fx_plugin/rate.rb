module GlobalReachPartners
  module FxPlugin
    class Rate
      attr_reader :guid
      attr_reader :buy_currency
      attr_reader :sell_currency
      attr_reader :exchange_rate

      def initialize(options)
        @guid = options[:guid]
        @buy_currency = options[:buy_currency]
        @sell_currency = options[:sell_currency]
        @exchange_rate = options[:exchange_rate]
      end
    end
  end
end
