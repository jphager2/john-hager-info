class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name, presence: true, length: {maximum: 40}
  EMAIL_REGEXP = /\A[\w+-.]+@[a-z\d\-.]+\.[a-z]+\z/
  validates :email, presence: true, format: { with: EMAIL_REGEXP }, 
                    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: {minimum: 6}

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private 
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token) 
    end
end
