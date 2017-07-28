module GlobalReachPartners
  class FxPluginRequest < Request
    def client
      GlobalReachPartners.fx_plugin_client
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
