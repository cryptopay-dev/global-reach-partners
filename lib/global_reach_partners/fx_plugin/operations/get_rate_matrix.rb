module GlobalReachPartners
  module FxPlugin
    module Operations
      module GetRateMatrix
        extend self

        def call
          message = { error_msg: '' }

          request = Request.new(:get_rate_matrix).call(message)
          result = request.body.dig(:get_rate_matrix_response, :get_rate_matrix_result)
          RateMatrix.new(result)
        end
      end
    end
  end
end
