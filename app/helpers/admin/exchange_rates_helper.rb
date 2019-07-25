module Admin::ExchangeRatesHelper

  def get_rate(date)
    data[date][target_rate]
  end

  def convert_to(date)
    @exchange_rate.amount / get_rate(date)
  end

  def compute_profit(date)
    i = data.keys.index(date)
    return 0 if i == 0
    profit = convert_to(data.keys[i-1]) - convert_to(date)
    if profit > 0
      content_tag(:span, profit, class: 'text-success')
    else
      content_tag(:span, profit, class: 'text-danger')
    end
  end

  def highest_lowest_value(date)
    max = data.values[0..data.keys.index(date)].max_by{|h,v| h.values }[target_rate]
    low = data.values[0..data.keys.index(date)].min_by{|h,v| h.values }[target_rate]

    min_max = content_tag(:span, max, class: 'text-success')
    min_max += " | "
    min_max += content_tag(:span, low, class: 'text-danger')
    return min_max
  end


  def chart_data
    color_list= []
    min_val =  data.min_by{|h,v| v[target_rate]}[1][target_rate]
    max_val = data.max_by{|h,v| v[target_rate]}[1][target_rate]
    chart_data = []
    colors = {}
    colors[min_val] = 'red'
    colors[max_val] = 'green'


    @exchange_rate.historical_duration.each do |k|
      if colors[k[1].values[0]].nil?
        color_list << 'blue'
      else
        color_list << colors[k[1].values[0]]
      end

      chart_data << [ k[0], k[1].values[0] ]
    end

    return column_chart chart_data, colors: color_list

  end

  private

  def data
    @exchange_rate.historical_duration
  end

  def target_rate
    @exchange_rate.target_currency
  end

end
