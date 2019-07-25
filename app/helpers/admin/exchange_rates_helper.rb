module Admin::ExchangeRatesHelper

  def get_rate(date)
    cur_value = data[date][target_rate]
    max = data.values.max_by{|h,v| h.values }[target_rate]
    low = data.values.min_by{|h,v| h.values }[target_rate]

    if max == cur_value
      content_tag(:span, cur_value, class: 'text-success')
    elsif low == cur_value
      content_tag(:span, cur_value, class: 'text-danger')
    else
      cur_value
    end

  end

  def convert_to(date)
    @exchange_rate.amount.to_f / data[date][target_rate]
  end

  def compute_profit(date)
    i = data.keys.index(date)
    return '--' if i == 0
    profit = convert_to(data.keys[i-1]) - convert_to(date)
    if profit > 0
      content_tag(:span, profit.round(2), class: 'text-success')
    elsif profit == 0
      content_tag(:span, profit.round(2), class: 'text-center')
    else
      content_tag(:span, profit.round(2), class: 'text-danger')
    end
  end

  def highest_lowest_value(date)
    max = data.values.max_by{|h,v| h.values }[target_rate]
    low = data.values.min_by{|h,v| h.values }[target_rate]

    min_max = content_tag(:span, max, class: 'text-success')
    min_max += " | "
    min_max += content_tag(:span, low, class: 'text-danger')
    return min_max
  end


  def chart_data

    chart_data = []
    @exchange_rate.historical_duration.each do |k|
      chart_data << [ k[0], k[1].values[0] ]
    end

    return line_chart chart_data

  end

  private

  def data
    @exchange_rate.historical_duration
  end

  def target_rate
    @exchange_rate.target_currency
  end

end
