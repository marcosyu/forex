FactoryBot.define do
  factory :exchange_rate do
    date{FFakker::Time.date}
    rate{ rand() }
    base_currency{ FFakker::Currency.code }
    target_currency{ FFakker::Currency.code }
  end

  factory :exchange_rate2 do
    date{FFakker::Time.date}
    rate{ rand() }
    base_currency{ FFakker::Currency.code }
    target_currency{ FFakker::Currency.code }
  end

end
