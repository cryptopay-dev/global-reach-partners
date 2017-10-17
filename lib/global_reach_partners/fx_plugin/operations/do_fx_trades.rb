module GlobalReachPartners
  module FxPlugin
    module Operations
      module DoFxTrades
        extend self

        delegate :logger, to: GlobalReachPartners

        def call(guid:, amount:, buy_currency:, sell_currency:, buying:, ref: nil)
          message = {
            'TradeType' => 'Single',
            'objTradeParam' => [
              {
                'clsBuySellCurrency' => {
                  'TradeType' => 'Single',
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
              }
            ]
          }

          logger.info("GlobalReachPartners.do_fx_trades start: #{message}")

          response = Request.new(:do_fx_trades).call(message)
          deal = Deal.new(response.body.dig(:do_fx_trades_response, :do_fx_trades_result))

          logger.info("GlobalReachPartners.do_fx_trades succeed: #{deal.raw}")

          deal
        rescue Error => e
          logger.error("GlobalReachPartners.do_fx_trades failed: #{e.message}, response: #{response}")
          raise
        end
      end
    end
  end
end
