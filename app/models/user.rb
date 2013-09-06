# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  has_many :orders, dependent: :destroy
	before_validation(:name_titleize)
	before_create :create_remember_token
  validates :name, presence: true, length: {maximum: 50}, uniqueness: true
  has_secure_password
  validates :password, length: { minimum: 6 }
  validate :no_underscore

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

	def name_titleize
      self.name=name.titleize
  end

  private

  def create_remember_token
  	self.remember_token = User.encrypt(User.new_remember_token)
  end

  def no_underscore
    if self.name.include? '_'
      errors.add :name, "cannot include an underscore(_)."
    end
  end
end
