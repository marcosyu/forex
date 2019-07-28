class ExchangeRateApis::FixerApiService

  def initialize args={}
    @start = 25.days.ago.to_date
    @end = Date.today
    @base = args[:base]
    @symbols = args[:symbols]
    @action = args[:action]
  end

  def call
    data = fetch_from_fixer
    data_to_value_series data
  end

  private

  def fetch_from_fixer
    response = Faraday.get(url_for_action, params_for_action)
    JSON.parse(response.body)
  end

  def url_for_action
    case action
    when 'latest'
      return "#{ENV['FIXER_URL']}/latest"
      # http://data.fixer.io/api/latest
    when 'by_date'
      return "#{ENV['FIXER_URL']}/#{@start}"
      # http://data.fixer.io/api/2013-12-24
    when 'histories'
      return "#{ENV['FIXER_URL']}/timeseries"
      # http://data.fixer.io/api/timeseries
    end
  end

  def params_for_action
    params ={
      access_key: ENV['FIXER_API_KEY'],
      base: @base,
      symbols: @symbols.join(',')
    }
    params!.merge({start: @start, end: @end}) if @action == 'histories'
  end

  def data_to_value_series data
    values = []
    if data['timeseries']
      data['rates'].keys.each do |day|
        values += data['rates'][day].map{|key,value| "('#{data['base']}', '#{key}',' #{Date.parse(day)}', '#{value}', '#{Date.today}', '#{Date.today}')" }
      end
    else
      values += data['rates'].map{|key,value| "('#{data['base']}','#{key}', '#{Date.parse(data['date'])}', '#{value}', '#{Date.today}', '#{Date.today}')" }
    end

    return values

  end

end
