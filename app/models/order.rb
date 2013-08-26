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
end
