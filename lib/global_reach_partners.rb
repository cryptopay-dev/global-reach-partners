require 'bigdecimal/util'

require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object'
require 'savon'

require 'global_reach_partners/errors'
require 'global_reach_partners/configuration'
require 'global_reach_partners/calendar'
require 'global_reach_partners/currency'
require 'global_reach_partners/request'
require 'global_reach_partners/trade_service_request'
require 'global_reach_partners/rate'
require 'global_reach_partners/operations'
require 'global_reach_partners/fx_plugin'

module GlobalReachPartners
  extend Operations

  LOG_FILTERS = %w[
    ClientCode
    Username
    Password
  ].freeze

  class << self
    attr :configuration,
      :fx_plugin_client,
      :trade_service_client

    delegate :logger, to: :configuration

    def configure
      @configuration ||= Configuration.new(
        debug: false,
        soap_version: '1.1'
      )
      yield(@configuration)
    end

    def fx_plugin_client(options = {})
      @fx_plugin_clients ||= {}
      @fx_plugin_clients[options] ||= client(fx_plugin_wsdl, options)
    end

    def trade_service_client
      @trade_service_client ||= client(trade_service_wsdl)
    end

    def closest_workday(date: Date.today, currencies: [])
      Calendar.closest_workday(date, currencies)
    end

    private

    def fx_plugin_wsdl
      if @configuration.fx_plugin_wsdl
        @configuration.fx_plugin_wsdl
      else
        @configuration.url + '/FXPlugin.asmx?WSDL'
      end
    end

    def trade_service_wsdl
      if @configuration.trade_service_wsdl
        @configuration.trade_service_wsdl
      else
        @configuration.url + '/TradeService.asmx?WSDL'
      end
    end

    def client(wsdl_or_url, read_timeout: nil)
      config = {
        logger: @configuration.logger,
        filters: LOG_FILTERS,
        wsdl: wsdl_or_url,
        namespace_identifier: nil,
        element_form_default: :unqualified,
        convert_request_keys_to: :camelcase
      }

      config[:proxy] = @configuration.proxy if @configuration.proxy.present?

      if @configuration.debug
        config[:log_level] = :debug
        config[:log] = true
        config[:pretty_print_xml] = true
      end

      if @configuration.soap_version.to_s == '1.2'
        config[:soap_version] = 2
        config[:env_namespace] = :soap12
      else
        config[:env_namespace] = :soap
      end

      config[:read_timeout] = read_timeout if read_timeout

      Savon.client(config)
    end
  end
end
