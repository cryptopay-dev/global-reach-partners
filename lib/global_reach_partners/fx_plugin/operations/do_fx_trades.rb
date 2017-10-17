module GlobalReachPartners
  module FxPlugin
    module Operations
      module DoFxTrades
        extend self

        delegate :logger, to: GlobalReachPartners

        def call(trades)
          buy_sells = Array.wrap(trades).map { |trade| build_buy_sell(trade) }

          message = {
            'TradeType' => 'Single',
            'objTradeParam' => {
              'clsBuySellCurrency' => buy_sells
            }
          }

          logger.info("GlobalReachPartners.do_fx_trades start: #{message}")

          response = Request.new(:do_fx_trades).call(message)
          result = response.body.dig(:do_fx_trades_response, :do_fx_trades_result)

          parse_deals(result).tap do |deals|
            logger.info("GlobalReachPartners.do_fx_trades succeed: #{deals.map(&:raw).join}")
          end
        rescue Error => e
          logger.error("GlobalReachPartners.do_fx_trades failed: #{e.message}, response: #{response}")
          raise
        end

        private

        def build_buy_sell(guid:, amount:, buy_currency:, sell_currency:, buying:, ref: nil)
          {
            'SettlementDate' => Date.today.strftime('%d/%m/%Y'),
            'IsDirectDebit' => false,
            'BuyingOrSelling' => buying ? 'Buy' : 'Sell',
            'BuyCurrency' => buy_currency,
            'SellCurrency' => sell_currency,
            'Amount' => amount,
            'Paymentcategory' => 'BPEN',
            'FXRateMatrixGuid' => guid,
            'TradeRef' => ref
          }
        end

        def parse_deals(result)
          check_for_errors(result)

          Nokogiri::XML.fragment(result[:success_message]).search('Status').map do |node|
            Deal.new(node)
          end
        end

        def check_for_errors(result)
          title = result[:error_message]
          return unless title

          outputs = Array.wrap(result.dig(:out_put_data_table, :diffgram, :document_element, :out_put_table))
          description = outputs.map { |output| output[:error_message] }.compact.join(', ')

          message = [title, description].compact.join(' ')

          raise Error, message
        end
      end
    end
  end
end
