class RemoveagendaFromSalas < ActiveRecord::Migration[5.2]
  def change
    remove_column :salas, :agendas_id
  end
end
