module AdminHelper
  def currencies
    Money::Currency.table.keys.map{|cur| cur.to_s.upcase }
  end
end
