module GlobalReachPartners
  module Operations
    # Attributes: :sell_currency: :buy_currency: :amount
    def get_rate(**attrs)
      rate = Rate.new(attrs)
      rate.fetch
      rate
    end

    def get_rate_matrix
      RateMatrix.fetch
    end

    def do_fx_trades(rate)
      message = { trade_type: 'Single' }

      buy_sell_currency = {
        trade_type: 'Single',
        settlement_date: Date.today.strftime('%d/%m/%Y'),
        is_direct_debit: true,
        buying_or_selling: 'Sell',
        sell_currency: 'USD',
        # sell_currency_country
        buy_currency: 'EUR',
        # buy_currency_country
        amount: 100,
        no_of_chaps: 1,
        no_of_bacs: 0,
        # bank_ID: 1,
        # payment_sending
        paymentcategory: 'BPEN',
        FX_rate_matrix_guid: rate[:sell].guid
        # trade_ref
      }

      message['objTradeParam'] = [
        { 'clsBuySellCurrency' => buy_sell_currency }
      ]

      response = FxPluginRequest.new(:do_fx_trades).call(message)
      Deal.new(response.body.dig(:do_fx_trades_response, :do_fx_trades_result))
    end

    def get_currencies
      message = { error_msg: '' }

      request = TradeServiceRequest.new(:get_currencies).call(message)
      currencies = request.body.dig(:get_currencies_response, :get_currencies_result, :diffgram, :new_data_set, :tbl)
      begin
        currencies.map do |currency|
          Currency.new(currency)
        end
      rescue
        return []
      end
    end

    def do_single_trade(type:, sell_currency:, buy_currency:, amount:)
      raise "Type #{type} does not match." unless type.to_s.in?(%w[buy sell])

      message = {
        trade_type: 'fundsonaccount',
        singletradeormultipletrade: 'single',
        #error_msg: '',
        dt_output: ''
      }

      message['objSingleTrade'] = {
        ben_name: 'Test1',
        payee_ac_IBAN: 'BE00000000000000',
        payment_curr: 'EUR',
        payment_amount: amount.to_d,
        payment_type: 'Express',
        payment_notes: 'Test API Payment',
        bank_name: 'KBC Bank NV',
        bank_address1: 'Address 1',
        bank_address2: 'Address 2',
        #bank_city: '',
        #bank_state: '',
        #bank_zip: '',
        bank_country: 'Belgium',
        bank_swift_code: 'KREXXXXB',
        bank_sort_code: '',
        #bank_routing_code: '',
        #IM_bank_name: '',
        #IM_bank_address1: '',
        #IM_bank_address2: '',
        #IM_bank_city: '',
        #IM_bank_state: '',
        #IM_bank_zip: '',
        #IM_bank_country: '',
        #IM_bank_swift: '',
        #IM_bank_ac_no: '',
        #new_payee_name: '',
        value_date: Date.today.to_s,
        temp_value_date: Date.today.to_s,
        sell_currency: 'USD',
        #sell_currency_ID: currency_id(sell_currency),
        #buy_currency_ID: currency_id(buy_currency),
        #trade_type: 'booktrade', # fundsonaccount
        #no_of_BACS: '',
        #no_of_CHAPS: '',
        #broker_booked: '',
        OPI_categories: 'PEN',
        beneficiary_add1: 'add1',
        beneficiary_add2: 'add2',
        beneficiary_add3: 'add3',
        #paymentcategory: '', # BPEN
        #division_name: '',
        #beneficiary_nationality: '',
        #vc_comp_ref: '',
        #by_order_of: '',
        #trade_ref: ''
      }
      # is_direct_debit: false,
      # no_of_chaps: 10,
      # no_of_bacs: 10,
      # paymentcategory: 'BPEN'

      TradeServiceRequest.new(:do_single_trade).call(message)
    end

    private def currency_id(currency)
      if currency.is_a?(GlobalReachPartners::Currency)
        currency.id
      else
        {
          'USD' => 1,
          'EUR' => 70,
          'PHP' => 41,
          'GBP' => 14
        }[currency]
        # @currencies ||= get_currencies
        # @currencies.find { |currency| currency.name == currency }.first
      end
    end
  end
end
