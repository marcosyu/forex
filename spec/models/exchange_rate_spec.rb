require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do

  describe 'relations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:base_currency) }
    it { should validate_presence_of(:target_currency) }
  end

end
