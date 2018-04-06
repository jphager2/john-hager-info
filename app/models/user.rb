class User < ApplicationRecord
  EMAIL_REGEXP = /\A[\w+-.]+@[a-z\d\-.]+\.[a-z]+\z/

  has_secure_password

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 40 }
  validates :email, presence: true, format: { with: EMAIL_REGEXP }, 
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, if: :new_record?

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private 

  def create_remember_token
    token = self.class.new_remember_token
    encrypted_token = self.class.encrypt(token) 

    self.remember_token = encrypted_token
  end
end
