class ExchangeRateServices

  def initialize(id)
    @@exchange_rate = ExchangeRate.find(id)
    @@base_currency = @@exchange_rate.base_currency
    @@symbols = @@exchange_rate.target_currency
  end

  def get_histories

    params = {
      access_key: ENV["CURRENCY_API_KEY"],
      start_date: 25.weeks.ago.strftime("%Y-%m-%d"),
      end_date: Date.today.strftime("%Y-%m-%d"),
      base: @@base_currency,
      symbols: @@symbols
    }
    url = "http://data.fixer.io/api/timeseries"
    params[:access_key] = "1f2722385bf2c7f87dba8b484911b141"
    # response = Faraday.get("#{url}/timeseries", params)

    response = Faraday.get("#{ENV["CURRENCY_URL"]}/timeseries", params)

    ## no need to cache the data since this would be done in the background job
    @@exchange_rate.update_attribute('historical_duration', JSON.parse(response.body)["rates"] )

  end

  class << self

    def get_currencies

      ## ideally this should be cached in local storage but heroku doesn't allow it.
      ## not enough time to map to S3 or cloud storage.

      file_url = Rails.root.join('tmp/storage/currencies.json')

      if File.exist?(file_url)
        return JSON.parse(File.read(file_url))
      else
        # response = Faraday.get("#{ENV["CURRENCY_URL"]}/latest", { access_key: ENV["CURRENCY_API_KEY"] })
        response = Faraday.get("http://data.fixer.io/api/latest", { access_key: "1f2722385bf2c7f87dba8b484911b141" })
        data = JSON.parse(response.body)

        ##catch the error

        if data[:success]
          currencies = JSON.parse(response.body)["rates"].keys
          File.open(Rails.root.join('tmp/storage/currencies.json'),'w'){|f| f.write currencies.to_json }
          return currencies
        else
          return data[:code]
        end

      end
    end

  end
end
