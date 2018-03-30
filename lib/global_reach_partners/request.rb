module GlobalReachPartners
  class Request
    GRP = 1
    CFXPlus = 2

    attr_reader :operation, :configuration

    def initialize(operation)
      @operation = operation
      @configuration = GlobalReachPartners.configuration
    end

    def call(operation_message, options = {})
      full_message = operation_message.merge(authentication)

      request = client(options).call(operation) do
        attributes(xmlns: 'http://tempuri.org/')
        message(full_message)
      end

      request.tap do |r|
        error_msg = r.body.dig(:get_rate_matrix_response, :error_msg)
        raise Error, error_msg if error_msg
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
