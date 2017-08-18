module GlobalReachPartners
  class RateMatrix
    attr_reader :source

    def fetch
      message = { error_msg: '' }

      request = FxPluginRequest.new(:get_rate_matrix).call(message)
      fetch_result = request.body.dig(:get_rate_matrix_response, :get_rate_matrix_result)
      @source = Nokogiri::XML(fetch_result).xpath('//FXRateMatrix')
    end

    def ack!
      message = {
        error_msg: '',
        guid: guid
      }

      response = FxPluginRequest.new(:set_ack).call(message)
      response.body.dig(:set_ack_response, :error_msg) == 'ForValidation'
    end

    def guid
      source.xpath('//GUID').first.text
    end

    def get_rates(pair)
      rates = {}

      @source.each do |fx|
        next if fx.search("CcyPair[text()='#{pair}']").blank?

        if fx.search('BuyCcy').text == pair[0...3]
          rates[:buy] = Rate.new(rate_attributes(fx))
        else
          rates[:sell] = Rate.new(rate_attributes(fx))
        end
      end

      rates
    end

    private def parse_source
      @source.each do |fx|
        Rate.new(rate_attributes(fx))
      end
    end

    private def rate_attributes(fx)
      {
        guid: fx.search('GUID').text,
        buy_currency: fx.search('BuyCcy').text,
        sell_currency: fx.search('SellCcy').text,
        exchange_rate: fx.search('Rate').text.to_f
      }
    end
  end
end
