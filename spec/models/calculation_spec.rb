require 'rails_helper'

RSpec.describe Calculation, type: :model do

  describe 'relations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:to) }
    it { should validate_presence_of(:from) }
  end

end
