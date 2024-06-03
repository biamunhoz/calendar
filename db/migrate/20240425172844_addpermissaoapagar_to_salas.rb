class AddpermissaoapagarToSalas < ActiveRecord::Migration[5.2]
  def change
    add_column :salas, :permitiapagarevento, :boolean, :default => true
  end
end
