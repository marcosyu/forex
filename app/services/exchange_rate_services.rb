class ExchangeRateServices

  def initialize args={}
    @attributes = args
    if args[:action] == 'histories' && args[:favorite_exchange_rate_id].present?
      exchange_rate = FavoriteExchangeRate.find(args[:favorite_exchange_rate_id])
      @attributes[:base] = exchange_rate.base_currency
      @attributes[:symbols] = exchange_rate.target_currency
    end
  end

  def call
    values = []
    case @provider
    when 'fixer_api'
      values += ExchangeRateApis::FixerApiService.new(@attributes.except(:provider)).call
    end

    if values.present?
      begin
        sql = "INSERT INTO exchange_rates (base_currency, target_currency, date, rate, created_at, updated_at) VALUES #{values.join(', ')}"
        ActiveRecord::Base.connection.execute(sql)
      rescue ActiveRecord::RecordNotUnique
        Rails.logger.error 'Duplicate Record'
      end
    end

  end

end
