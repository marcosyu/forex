class Calculation < ApplicationRecord
  belongs_to :user

  validates :value, :to, :from, presence: true
end
