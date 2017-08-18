module GlobalReachPartners
  class Request
    GRP = 1
    CFXPlus = 2

    attr_reader :operation, :configuration

    def initialize(operation)
      @operation = operation
      @configuration = GlobalReachPartners.configuration
    end

    def call(operation_message)
      full_message = operation_message.merge(authentication)

      client.call(operation) do
        attributes(xmlns: 'http://tempuri.org/')
        message(full_message)
      end
    end

    def client
      raise NotImplementedError, 'You need to define method in subclass'
    end

    def authentication
      raise NotImplementedError, 'You need to define method in subclass'
    end
  end
end
