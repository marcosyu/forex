module CalculationHelper

  def currency_select
    options = []
    @currencies.map{|currency|  content_tag :option, currency }
    return content_tag :select, options
  end

end
