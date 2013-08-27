class User < ActiveRecord::Base
	before_save { self.name = name.titleize }
  attr_accessible :name, :password, :password_confirmation
  validates :name, presence: true, length: {maximum: 50}, uniqueness: true
  has_secure_password
  validates :password, length: { minimum: 6 }
end
