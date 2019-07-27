FactoryBot.define do
  factory :favorite_exchange_rate do
    amount{ rand() }
    base_currency{ FFakker::Currency.code }
    target_currency{ FFakker::Currency.code }
  end
end
