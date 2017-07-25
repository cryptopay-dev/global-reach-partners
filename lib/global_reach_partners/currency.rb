module GlobalReachPartners
  class Currency
    attr_reader :id, :name, :description

    def initialize(options)
      @id = options[:currency_id]
      @name = options[:currency_name]
      @description = options[:currency_description]
    end
  end
end
