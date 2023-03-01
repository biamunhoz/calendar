class AddDisablefdsToSalas < ActiveRecord::Migration[5.2]
  def change
    add_column :salas, :disablefds, :boolean, :default => false
  end
end