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
  attr_accessible :name, :bunk, :white, :orange, :blue, :paid
  validates :name, :bunk, presence: true
  validate :ordered_discs

  def ordered_discs
  	if (self.blue.to_i + self.white.to_i + self.orange.to_i) <= 0
  		errors[:base]<<"No discs ordered"
  	end
  end
end

