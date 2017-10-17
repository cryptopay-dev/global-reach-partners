module GlobalReachPartners
  module FxPlugin
    class RateMatrix
      def initialize(result)
        @result = result
      end

      def ack!
        Operations::SetAck.call(guid)
      end

      def guid
        source.at_xpath('//GUID').text
      end

      def get_rates(pair)
        rates = {}

        source.each do |fx|
          next if fx.search("CcyPair[text()='#{pair}']").blank?

          if fx.search('BuyCcy').text == pair[0...3]
            rates[:buy] = Rate.new(rate_attributes(fx))
          else
            rates[:sell] = Rate.new(rate_attributes(fx))
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
