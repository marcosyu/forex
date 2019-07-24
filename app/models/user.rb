class User < ApplicationRecord

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :calculations, dependent: :destroy

  validates :email, :provider, :uid, presence: true

  def self.from_omniauth(auth)
    where(email: auth.email, provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.token = auth.credentials.token
      user.expires = auth.credentials.expires
      user.expires_at = auth.credentials.expires_at
      user.refresh_token = auth.credentials.refresh_token
    end
  end
end
