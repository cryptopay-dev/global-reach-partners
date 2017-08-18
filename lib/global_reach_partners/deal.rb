module GlobalReachPartners
  class Deal
    attr_reader :deal_number,
      :settelment_date,
      :buy_currency,
      :sell_currency,
      :sell_amount,
      :exchange_rate,
      :trade_direction,
      :trade_ref

    def initialize(answer)
      source = Nokogiri::XML(answer[:success_message]).xpath('//Status')
      require 'pry'; binding.pry

      @deal_number = source.search('//DealNo').text
      @settelment_date = source.search('//SettelmentDate').text
      @buy_currency = source.search('//BuyCurrency').text
      @sell_currency = source.search('//SellCurrency').text
      @sell_amount = source.search('//SellAmount').text
      @exchange_rate = source.search('//ExchangeRate').text
      @trade_direction = source.search('//TradeDirection').text
      @trade_ref = source.search('//TradeRef').text
    end
  end
end
