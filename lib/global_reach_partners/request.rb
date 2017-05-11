module GlobalReachPartners
  class Request
    GRP = 1
    CFXPlus = 2

    attr_reader :operation, :client, :configuration

    def initialize(operation)
      @operation = operation
      @client = GlobalReachPartners.client
      @configuration = GlobalReachPartners.configuration
    end

    def call(operation_message)
      client.call(operation) do
        attributes(xmlns: 'http://tempuri.org/')
        message(operation_message.merge(authentication))
      end
    end

    private def authentication
      {
        client_login: configuration.client_code,
        user_name: configuration.username,
        password: configuration.password,
        group_ID: GRP
      }
    end
  end
end
