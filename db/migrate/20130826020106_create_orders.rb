class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.string :name
    	t.string :bunk
    	t.integer :white
    	t.integer :orange
    	t.integer :blue
    	t.boolean :paid
        t.boolean :received

    	t.timestamps
    end
  end
end
