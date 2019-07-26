class ExchangeRateServices

  def initialize(id)
    @@favorite_exchange_rate = FavoriteExchangeRate.find(id)
  end

  def daily_update
    base_currencies = FavoriteExchangeRate.pluck(:base_currency).uniq
    base_currencies.each do |currency|
      symbols = FavoriteExchangeRate.where(base_currency: currency).map(&:target_currency)

      params = {
        access_key: ENV["CURRENCY_API_KEY"],
        base: @@favorite_exchange_rate.base_currency,
        symbols: symbols.join(',')
      }

      # response = Faraday.get("#{ENV['CURRENCY_URL']}/latest", params)
      # update_record(JSON.parse(response.body)["rates"])

      ## for testing only
      response = File.read(Rails.root+ "daily.json")
      update_record(JSON.parse(response)["rates"], 'daily')
    end
  end

  def populate_exchange_rate
    params = {
      start_date: 25.days.ago,
      end_date: Date.today,
      base: @@favorite_exchange_rate.base_currency,
      symbols: @@favorite_exchange_rate.target_currency
    }

    # response = Faraday.get("#{ENV['CURRENCY_URL']}/timeseries", params)
    # update_record(JSON.parse(response.body)["rates"])

    ## for testing only
    response = File.read(Rails.root+ "php_usd.json")
    update_record(JSON.parse(response)["rates"])

  end


  private

  def update_record data, daily=false
    sql = daily ? by_symbol(data) : by_date(data)
    ActiveRecord::Base.connection.execute(sql) if sql.present?
  end

  def by_symbol data
    sql = 'INSERT INTO exchange_rates (base_currency, target_currency, date, rate, created_at, updated_at) VALUES'
    values = []
    data.keys.each do |key|
      exchange_rate = ExchangeRate.new({ rate: data[key], base_currency: @@favorite_exchange_rate.base_currency, target_currency: key, date:  Date.today })
      if exchange_rate.valid?
        values << "('#{ @@favorite_exchange_rate.base_currency}','#{key}', '#{Date.today}','#{data[key]}', '#{Time.now}', '#{Time.now}')"
      end
    end
  end

  def by_date data
    sql = 'INSERT INTO exchange_rates (base_currency, target_currency, date, rate, created_at, updated_at) VALUES'
    values = []
    data.keys.each do |key|
      rate = data[key][@@favorite_exchange_rate.target_currency]
      exchange_rate = ExchangeRate.new({ rate: rate, base_currency: @@favorite_exchange_rate.base_currency, target_currency: @@favorite_exchange_rate.target_currency, date:  DateTime.parse(key) })
      if exchange_rate.valid?
        values << "('#{ @@favorite_exchange_rate.base_currency}', '#{@@favorite_exchange_rate.target_currency}',' #{DateTime.parse(key)}', #{rate}, '#{Time.now}', '#{Time.now}')"
      end
    end
    return nil if values.empty?
    sql += "#{values.join(',')};"
  end
end
