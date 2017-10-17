module GlobalReachPartners
  module FxPlugin
    class RateMatrix
      def initialize(result)
        @result = result
      end

      def self.fetch
        message = { error_msg: '' }

        request = FxPlugin::Request.new(:get_rate_matrix).call(message)
        result = request.body.dig(:get_rate_matrix_response, :get_rate_matrix_result)
        new(result)
      end

      def ack!
        message = {
          error_msg: '',
          guid: guid
        }

        response = FxPlugin::Request.new(:set_ack).call(message)
        response.body.dig(:set_ack_response, :error_msg) == 'ForValidation'
      end

      def guid
        source.at_xpath('//GUID').text
      end

      def get_rates(pair)
        rates = {}

        source.each do |fx|
          next if fx.search("CcyPair[text()='#{pair}']").blank?

          if fx.search('BuyCcy').text == pair[0...3]
            rates[:buy] = FxPlugin::Rate.new(rate_attributes(fx))
          else
            rates[:sell] = FxPlugin::Rate.new(rate_attributes(fx))
          end
        end

        rates
      end

      private

      def marshal_dump
        @result
      end

      def marshal_load(xml)
        @result = xml
      end

      def rate_attributes(fx)
        {
          guid: fx.search('GUID').text,
          buy_currency: fx.search('BuyCcy').text,
          sell_currency: fx.search('SellCcy').text,
          exchange_rate: fx.search('Rate').text.to_f
        }
      end

      def source
        @source ||= Nokogiri::XML(@result).xpath('//FXRateMatrix')
      end
    end
  end
end
