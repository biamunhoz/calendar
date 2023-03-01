class AddTimeToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :timeini, :time
    add_column :events, :timefim, :time    
  end
end
