require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object'
require 'savon'

require 'global_reach_partners/configuration'
require 'global_reach_partners/currency'
require 'global_reach_partners/request'
require 'global_reach_partners/fx_plugin_request'
require 'global_reach_partners/trade_service_request'
require 'global_reach_partners/deal'
require 'global_reach_partners/rate'
require 'global_reach_partners/rate_matrix'
require 'global_reach_partners/operations'

module GlobalReachPartners
  extend Operations

  class << self
    attr :configuration,
      :fx_plugin_client,
      :trade_service_client

    def configure
      @configuration ||= Configuration.new(
        debug: false,
        soap_version: '1.1'
      )
      yield(@configuration)
    end

    def fx_plugin_client
      return @fx_plugin_client if @fx_plugin_client

      @fx_plugin_client = client('/FXPlugin.asmx?WSDL')
    end

    def trade_service_client
      return @trade_service_client if @trade_service_client

      @trade_service_client = client('/TradeService.asmx?WSDL')
    end

    private def client(path)
      wsdl_url = @configuration.url + path
      use_debug = @configuration.debug
      soap_version = @configuration.soap_version.to_s

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

        wsdl(wsdl_url)
        namespace_identifier(nil)
        element_form_default(:unqualified)
        convert_request_keys_to(:camelcase)
      end
    end
  end
end