class AddReceived < ActiveRecord::Migration
  def up
  	add_column :orders, :received, :boolean, :default => false
  end

  def down
  end
end
