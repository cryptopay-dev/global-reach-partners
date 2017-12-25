module GlobalReachPartners
  module FxPlugin
    class Request < GlobalReachPartners::Request
      def client(options = {})
        GlobalReachPartners.fx_plugin_client(options)
      end

      def authentication
        {
          client_code: configuration.client_code,
          username: configuration.username,
          password: configuration.password,
          group_ID: GRP
        }
      end
    end
  end
end
