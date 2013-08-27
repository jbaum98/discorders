# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  bunk       :string(255)
#  white      :integer
#  orange     :integer
#  blue       :integer
#  paid       :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Order < ActiveRecord::Base
  attr_accessible :name, :bunk, :white, :orange, :blue, :paid, :received
  
  def total
  	self.blue+self.white+self.orange
  end

  def price
  	self.total*8
  end
  validates :name, :bunk, presence: true
  validate :ordered_discs

  def ordered_discs
  	if self.total <= 0
  		errors[:base]<<"No discs ordered"
  	end
  end
end

