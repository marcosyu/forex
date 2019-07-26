module Admin::ExchangeRatesHelper
  include ::AdminHelper

  def show_rate(exchange_rate)

    max = rates.max_by{|h| h.rate }
    low = rates.min_by{|h| h.rate }

    if max == amount
      content_tag(:span, amount.round(2), class: 'text-success')
    elsif low == amount
      content_tag(:span, amount.round(2), class: 'text-danger')
    else
      amount.round(2)
    end
  end

  def convert_to(exchange_rate)
    amount / exchange_rate.rate.to_f
  end

  def compute_profit(exchange_rate)
    i = rates.index(exchange_rate)
    return '--' if i == 0
    profit = convert_to(rates[i-1]) - convert_to(exchange_rate)

    if profit > 0
      content_tag(:span, profit.round(2), class: 'text-success')
    elsif profit == 0
      content_tag(:span, profit.round(2), class: 'text-center')
    else
      content_tag(:span, profit.round(2), class: 'text-danger')
    end
  end

  def chart_data

    chart_data = []
    rates.each do |exchange_rate|
      chart_data << [ exchange_rate.date, exchange_rate.rate ]
    end

    return line_chart chart_data

  end

  private

  def amount
    @favorite_exchange_rate.amount.to_f
  end

  def rates
    @favorite_exchange_rate.rates
  end

  def target_rate
    @exchange_rate.target_currency
  end

end
