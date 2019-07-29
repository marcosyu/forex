class ExchangeRateApis::FixerApiService

  def initialize args={}
    @attributes = args
    @attributes[:start] ||= 25.days.ago.to_date
    @attributes[:end] ||= Date.today
  end

  def call
    data = fetch_from_fixer
    if data.class == Array
      mapped_data = data.map{|d| data_to_value_series d }
    else
      mapped_data = data_to_value_series(data)
    end
    return nil if mapped_data.blank?
    return mapped_data.class == Array ? mapped_data.join(',') : mapped_data
  end

  private

  def fetch_from_fixer
    params = params_for_action

    if params.class == Array
      data = []
      params.each do |param|
        response = Faraday.get(url_for_action(@attributes[:action]), param)
        break nil unless response["success"]
        data << JSON.parse(response.body)
      end
      Rails.logger.warn "call count #{data.count}"
    else
      return get_histories if @attributes[:action] == "histories" ### workaround for basic account
      response = Faraday.get(url_for_action, params)
      data = JSON.parse(response.body)
    end
    return data

  end

  def url_for_action action ### needed args to call to get_histories
    case action
    when 'latest'
      return "#{ENV['FIXER_API_URL']}/latest"
    when 'by_date'
      return "#{ENV['FIXER_API_URL']}/#{@attributes[:start].strftime('%Y-%m-%d')}"
      # http://data.fixer.io/api/2013-12-24
    when 'histories'
      return "#{ENV['FIXER_API_URL']}/timeseries"
      # http://data.fixer.io/api/timeseries
    end
  end

  def params_for_action
    if @attributes[:currency_pairs].present?
      params = []
      @attributes[:currency_pairs].keys.each do |key|
        params << {
          access_key: ENV['FIXER_API_KEY'],
          # base: key,
          symbols: @attributes[:currency_pairs][key].join(',')
        }
      end
    else
      params ={
        access_key: ENV['FIXER_API_KEY'],
        # base: @attributes[:base],
        symbols:  @attributes[:symbols]
      }
      params.merge!({start: @attributes[:start].strftime('%Y-%m-%d'), end: @attributes[:end].strftime('%Y-%m-%d')}) if @attributes[:action] == 'histories'
    end
    params
  end

  def data_to_value_series data
    values = []

    if data['timeseries']
      data['rates'].keys.each do |day|
        values += data['rates'][day].map{|key,value| "('#{data['base']}', '#{key}',' #{Date.parse(day)}', '#{value}', '#{Date.today}', '#{Date.today}')" }
      end
    elsif data.class == Array ### workaround for basic account
      data.each do |datum|
        values += datum['rates'].map{|key,value| "('#{data['base']}','#{key}', '#{Date.parse(data['date'])}', '#{value.round(6)}', '#{Date.today}', '#{Date.today}')" }
      end
    else
      values += data['rates'].map{|key,value| "('#{data['base']}','#{key}', '#{Date.parse(data['date'])}', '#{value.round(6)}', '#{Date.today}', '#{Date.today}')" }
    end

    return values

  end

  def get_histories
    data = []
    (25.days.ago.to_date..Date.today).each do |date|
      @attributes[:start] = date
      response = Faraday.get(url_for_action('by_date'), params_for_action)
      break nil unless response["success"]
      data << JSON.parse(response.body)
    end
    Rails.logger.warn "call count #{data.count}"
    data
  end
end
