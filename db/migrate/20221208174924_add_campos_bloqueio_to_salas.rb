class AddCamposBloqueioToSalas < ActiveRecord::Migration[5.2]
  def change

    add_column :salas, :bloqforaintervalo, :boolean, :default => false
    add_column :salas, :prihoraini, :time
    add_column :salas, :prihorafim, :time
    add_column :salas, :seghoraini, :time
    add_column :salas, :seghorafim, :time
    add_column :salas, :valorinterval, :integer
  end
end
