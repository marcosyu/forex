class ExchangeRateServices

  def initialize args={}
    @attributes = args

    if args[:action] == 'histories' && args[:favorite_exchange_rate_id].present?
      exchange_rate = FavoriteExchangeRate.find(args[:favorite_exchange_rate_id])
      @attributes[:base] = exchange_rate.base_currency
      @attributes[:symbols] = exchange_rate.target_currency
    elsif args[:action] == 'latest'
      @attributes[:currency_pairs] = currency_pairs
    end
  end

  def call
    byebug
    values = get_values_from_api
    if values.present?
      begin
        sql = "INSERT INTO exchange_rates (base_currency, target_currency, date, rate, created_at, updated_at) VALUES #{values}"
        ActiveRecord::Base.connection.execute(sql)
      rescue ActiveRecord::RecordNotUnique
        Rails.logger.error 'Duplicate Record'
      end
    end

  end

  private

  def get_values_from_api
    case @attributes[:provider]
    when 'fixer_api'
      data = ExchangeRateApis::FixerApiService.new(@attributes.except(:provider)).call
    end
  end


  def currency_pairs
    rates = FavoriteExchangeRate.all.map{|rate| [rate.base_currency, rate.target_currency] }
    rates.group_by(&:first).transform_values { |v| v.map(&:last) }
  end
end
