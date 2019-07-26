class User < ApplicationRecord

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :favorite_exchange_rates, dependent: :destroy

  validates :email, :provider, :uid, presence: true

  def self.from_omniauth(auth)
    where(email: auth.info.email, provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.token = auth.credentials.token
      user.expires = auth.credentials.expires
      user.expires_at = auth.credentials.expires_at
      user.refresh_token = auth.credentials.refresh_token
    end
  end
end
