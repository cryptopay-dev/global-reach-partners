module GlobalReachPartners
  class Configuration
    attr_accessor :client_code
    attr_accessor :username
    attr_accessor :password
    attr_accessor :proxy
    attr_accessor :url
    attr_accessor :trade_service_wsdl
    attr_accessor :fx_plugin_wsdl

    # Default values
    attr_accessor :debug
    attr_accessor :soap_version

    def initialize(**attrs)
      attrs.each do |key, value|
        public_send("#{key}=", value)
      end
    end
  end
end
