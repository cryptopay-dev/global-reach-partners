module GlobalReachPartners
  class Configuration
    attr_accessor :client_code, :username, :password, :url, :proxy

    # Default values
    attr_accessor :debug, :soap_version

    def initialize(**attrs)
      attrs.each do |key, value|
        public_send("#{key}=", value)
      end
    end
  end
end
