class ExchangeRateServices

  def initialize(id =nil)
    @@favorite_exchange_rate = FavoriteExchangeRate.find(id) if id.present?
  end

  def fetch_popular_exchange_rates
    popular_pairs = ["JPY", "CHF", "CAD", "AUD", "GBP", "EUR", "USD" ]
    popular_pairs.each do |currency|
      symbols = popular_pairs.select{|value| value!=currency }
      (25.days.ago.to_date.. Date.today).each do |date|
        response = Faraday.get("#{ENV['CURRENCY_URL']}/#{date}", access_key: ENV["CURRENCY_API_KEY"])
        update_record(JSON.parse(response.body)["rates"], true, currency)
      end
    end
  end

  def populate_exchange_rate
    params = {
      access_key: ENV["CURRENCY_API_KEY"]
      start_date: 25.days.ago,
      end_date: Date.today,
      base: @@favorite_exchange_rate.base_currency,
      symbols: @@favorite_exchange_rate.target_currency,
    }

    response = Faraday.get("#{ENV['CURRENCY_URL']}/timeseries", params)
    update_record(JSON.parse(response.body)["rates"])

  end

  def daily_update
    base_currencies = ExchangeRate.pluck(:base_currency).uniq
    base_currencies.each do |currency|
      symbols = ExchangeRate.where(base_currency: currency).map(&:target_currency)

      params = {
        access_key: ENV["CURRENCY_API_KEY"],
        base: currency,
        symbols: symbols.join(',')
      }

      response = Faraday.get("#{ENV['CURRENCY_URL']}/latest", params)
      update_record(JSON.parse(response.body)["rates"])
    end

  end

  private

  def update_record data, daily=false, base_currency=nil
    sql = daily ? by_symbol(data, base_currency) : by_date(data)
    ActiveRecord::Base.connection.execute(sql) if sql.present?
  end

  def by_symbol data, base_currency
    values = []
    data.keys.each do |key|
      exchange_rate = ExchangeRate.new({ rate: data[key], base_currency: base_currency, target_currency: key, date:  Date.today })
      if exchange_rate.valid?
        values << "('#{ base_currency}','#{key}', '#{Date.today}','#{data[key]}', '#{Time.now}', '#{Time.now}')"
      end
    end
    map_to_sql(values)
  end

  def by_date data
    values = []
    data.keys.each do |key|
      rate = data[key][@@favorite_exchange_rate.target_currency]
      exchange_rate = ExchangeRate.new({ rate: rate, base_currency: @@favorite_exchange_rate.base_currency, target_currency: @@favorite_exchange_rate.target_currency, date:  DateTime.parse(key) })

      if exchange_rate.valid?
        values << "('#{ @@favorite_exchange_rate.base_currency}', '#{@@favorite_exchange_rate.target_currency}',' #{DateTime.parse(key)}', #{rate}, '#{Time.now}', '#{Time.now}')"
      end
    end
    map_to_sql(values)
  end

  def map_to_sql values
    return nil if values.empty?
    sql = 'INSERT INTO exchange_rates (base_currency, target_currency, date, rate, created_at, updated_at) VALUES #{values.join(',')};'
  end
end
