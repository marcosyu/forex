module Admin::ExchangeRatesHelper

  def get_rate(date)
    data[date][target_rate]
  end

  def convert_to(date)
    @exchange_rate.amount / get_rate(date)
  end

  def compute_profit(date)
    i = data.keys.index(date)

    profit = convert_to(data.keys[i-1]) - convert_to(date)
    if profit > 0
      content_tag(:span, profit, class: 'text-success')
    else
      content_tag(:span, profit, class: 'text-danger')
    end
  end

  private

  def data
    @exchange_rate.historical_duration
  end

  def target_rate
    @exchange_rate.target_currency
  end

end
