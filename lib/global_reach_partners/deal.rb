module GlobalReachPartners
  class Deal
    attr_reader :deal_number,
      :settlement_date,
      :buy_currency,
      :buy_amount,
      :sell_currency,
      :sell_amount,
      :exchange_rate,
      :trade_direction,
      :trade_ref,
      :raw

    def initialize(answer)
      check_for_error(answer)

      @raw = answer[:success_message]
      source = Nokogiri::XML(@raw).xpath('//Status')

      @deal_number = source.search('//DealNo').text
      @settlement_date = Date.parse(source.search('//SettelementDate').text)

      @buy_currency = source.search('//BuyCurrency').text
      @buy_amount = string_to_decimal(source.search('//BuyAmount').text)

      @sell_currency = source.search('//SellCurrency').text
      @sell_amount = string_to_decimal(source.search('//SellAmount').text)

      @exchange_rate = string_to_decimal(source.search('//ExchangeRate').text)
      @trade_direction = source.search('//TradeDirection').text
      @trade_ref = source.search('//TradeRef').text
    end

    private

    def check_for_error(answer)
      title = answer[:error_message]
      return unless title

      description = answer.dig(:out_put_data_table, :diffgram, :document_element, :out_put_table, :error_message)&.strip
      message = [title, description].compact.join(' ')

      raise Error, message
    end

    # 1,201.90 => BigDecimal.new('1201.90')
    def string_to_decimal(string)
      string.delete(',').to_d
    end
  end
end
