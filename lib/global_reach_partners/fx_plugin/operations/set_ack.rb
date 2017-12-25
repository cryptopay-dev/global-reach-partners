module GlobalReachPartners
  module FxPlugin
    module Operations
      module SetAck
        extend self

        delegate :logger, to: GlobalReachPartners

        def call(guid)
          logger.info("GlobalReachPartners.set_ack start: #{guid}")

          message = {
            error_msg: '',
            guid: guid
          }

          response = Request.new(:set_ack).call(message)

          logger.info("GlobalReachPartners.set_ack succeed: #{response}")

          response.body.dig(:set_ack_response, :error_msg) == 'ForValidation'
        end
      end
    end
  end
end
