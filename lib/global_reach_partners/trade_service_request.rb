module GlobalReachPartners
  class TradeServiceRequest < Request
    def client
      GlobalReachPartners.trade_service_client
    end

    def authentication
      {
        client_login: configuration.client_code,
        user_name: configuration.username,
        password: configuration.password,
        group_ID: GRP
      }
    end
  end
end
