class AddagendaToSalas < ActiveRecord::Migration[5.2]
  def change
    add_column :salas, :agenda_id , :integer, :references => "agenda"
  end
end
