class ExchangeRateServices

  def initialize(id)
    @@exchange_rate = ExchangeRate.find(id)
    @@base_currency = @@exchange_rate.base_currency
    @@symbols = @@exchange_rate.target_currency
  end

  def get_histories
    data = {}
    (30.days.ago.to_date..Date.today).each do |date|
      rate = fetch_data(date)
      data[date.strftime('%Y-%m-%d')]= rate
    end

    @@exchange_rate.update_attribute('historical_duration', data )
  end

  def fetch_data date
    params = {
      access_key: ENV["CURRENCY_API_KEY"],
      base: @@base_currency,
      symbols: @@symbols
    }
    response = Faraday.get("#{ENV['CURRENCY_URL']}/#{date.strftime('%Y-%m-%d')}", params)

    return JSON.parse(response.body)["rates"]

  end

  class << self

    def get_currencies

      ## ideally this should be cached in local storage but heroku doesn't allow it.
      ## not enough time to map to S3 or cloud storage.

      file_url = Rails.root.join('tmp/storage/currencies.json')

      if File.exist?(file_url)
        return JSON.parse(File.read(file_url))
      else
        response = Faraday.get("#{ENV["CURRENCY_URL"]}/latest", { access_key: ENV["CURRENCY_API_KEY"] })
        data = JSON.parse(response.body)

        ##catch the error
        if data["success"]
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
