module GlobalReachPartners
  module FxPlugin
    module Operations
      module SetAck
        extend self

        def call(guid)
          message = {
            error_msg: '',
            guid: guid
          }

          response = Request.new(:set_ack).call(message)
          response.body.dig(:set_ack_response, :error_msg) == 'ForValidation'
        end
      end
    end
  end
end
