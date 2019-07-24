require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'relations' do
    it { should have_many(:calculations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }
  end
end
