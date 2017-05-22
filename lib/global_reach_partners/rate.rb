module GlobalReachPartners
  class Rate
    attr_reader :exchange_rate, :convert_amount, :amount, :buy_currency, :sell_currency

    def initialize(options)
      @amount = options[:amount]
      @buy_currency = options[:buy_currency]
      @sell_currency = options[:sell_currency]
    end

    def fetch
      message = {}
      message['objRate'] = {
        buy_amount: amount,
        sell_curr: sell_currency,
        buy_curr: buy_currency,
        value_date: Time.current.utc.iso8601
      }

      request = Request.new(:get_rate).call(message)
      fetch_result = request.body.dig(:get_rate_response, :get_rate_result)

      @exchange_rate = fetch_result[:exchange_rate].to_d
      @convert_amount = fetch_result[:convert_amount].to_d
    end
  end
end
