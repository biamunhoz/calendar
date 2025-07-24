class AddAnonimoToSalas < ActiveRecord::Migration[5.2]
  def change
    add_column :salas, :anonimo, :boolean, :default => false
  end
end
