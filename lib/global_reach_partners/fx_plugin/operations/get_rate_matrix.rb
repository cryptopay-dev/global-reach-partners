module GlobalReachPartners
  module FxPlugin
    module Operations
      module GetRateMatrix
        extend self

        delegate :logger, to: GlobalReachPartners

        def call
          logger.info('GlobalReachPartners.get_rate_matrix start')

          message = { error_msg: '' }

          request = Request.new(:get_rate_matrix).call(message)

          logger.info('GlobalReachPartners.get_rate_matrix succeed')

          result = request.body.dig(:get_rate_matrix_response, :get_rate_matrix_result)
          RateMatrix.new(result)
        end
      end
    end
  end
end
