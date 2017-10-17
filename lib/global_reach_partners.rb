require 'bigdecimal/util'

require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object'
require 'savon'

require 'global_reach_partners/errors'
require 'global_reach_partners/configuration'
require 'global_reach_partners/currency'
require 'global_reach_partners/request'
require 'global_reach_partners/trade_service_request'
require 'global_reach_partners/deal'
require 'global_reach_partners/rate'
require 'global_reach_partners/rate_matrix'
require 'global_reach_partners/operations'
require 'global_reach_partners/fx_plugin'

module GlobalReachPartners
  extend Operations

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

    def fx_plugin_client
      @fx_plugin_client ||= client(fx_plugin_wsdl)
    end

    def trade_service_client
      @trade_service_client ||= client(trade_service_wsdl)
    end

    private def fx_plugin_wsdl
      if @configuration.fx_plugin_wsdl
        @configuration.fx_plugin_wsdl
      else
        @configuration.url + '/FXPlugin.asmx?WSDL'
      end
    end

    private def trade_service_wsdl
      if @configuration.trade_service_wsdl
        @configuration.trade_service_wsdl
      else
        @configuration.url + '/TradeService.asmx?WSDL'
      end
    end

    private def client(wsdl_or_url)
      proxy_url = @configuration.proxy
      use_debug = @configuration.debug
      soap_version = @configuration.soap_version.to_s
      configuration_logger = @configuration.logger

      @client = Savon.client do
        if use_debug
          log_level(:debug)
          log(true)
          pretty_print_xml(true)
        end

        if soap_version.to_s == '1.2'
          soap_version(2)
          env_namespace(:soap12)
        else
          env_namespace(:soap)
        end

        logger(configuration_logger)

        wsdl(wsdl_or_url)
        proxy(proxy_url) if proxy_url.present?

        namespace_identifier(nil)
        element_form_default(:unqualified)
        convert_request_keys_to(:camelcase)
      end
    end
  end
end
