require 'rails_helper'

RSpec.describe FavoriteExchangeRate, type: :model do

  describe 'validations' do
    it { should belong_to(:user) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:base_currency) }
    it { should validate_presence_of(:target_currency) }
  end

end
