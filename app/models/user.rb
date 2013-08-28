class User < ActiveRecord::Base
	before_save { self.name = name.titleize }
  validates :name, presence: true, length: {maximum: 50}, uniqueness: true
  has_secure_password
  validates :password, length: { minimum: 6 }
end
