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
#  received   :boolean          default(FALSE)
#  user_id    :integer
#

class Order < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :bunk, :white, :orange, :blue, :paid, :received, :price
  before_validation {self.name = name.titleize; self.bunk=bunk.capitalize}
  before_validation {match_data = /([A,a,B,b])(\d{1,2})/.match self.bunk
              if match_data
                self.bunk = "#{match_data[1].capitalize}-#{match_data[2]}"
              end
              }
  
  def total
  	self.blue+self.white+self.orange
  end

  def price
  	self.total*8
  end

  validates :name, :bunk, presence: true
  validates :name, uniqueness: {scope: [:user_id, :bunk]}
  validate :ordered_discs
  validate :paid_before_received

  def ordered_discs
  	if self.total <= 0
  		errors[:base]<<"No discs ordered"
  	end
  end

  def paid_before_received
    if not self.paid and self.received
      errors.add :received, "before paid."
    end
  end


end


