require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'relations' do
    it { should have_many(:exchange_rates) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }
  end
end
