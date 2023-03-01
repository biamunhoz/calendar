class AddValidacaoextraToAgenda < ActiveRecord::Migration[5.2]
  def change
    add_column :agendas, :validaextra, :boolean
  end
end
