class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  # def self.from_omniauth(auth)
  #   where(email: auth.info.email).first_or_initialize do |user|
  #     # user.username = auth.info.name
  #     user.username = auth.info.email.scan(/(.+)@/).flatten[0]
  #     user.email = auth.info.email
  #     user.password = SecureRandom.hex
  #   end
  # end
end
