class User < ActiveRecord::Base
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

  def database_path
  	"#{Rails.root}/db/users_dbs/#{self.name.downcase.gsub(' ', '_')}.yml"
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
