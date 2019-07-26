require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do

  describe 'validations' do
    it { should validate_uniqueness_of(:date).scoped_to(:base_currency, :target_currency) }
    it { should validate_presence_of(:rate) }
    it { should validate_presence_of(:base_currency) }
    it { should validate_presence_of(:target_currency) }
  end

end
