class AddTipoToAgenda < ActiveRecord::Migration[5.2]
  def change
    add_column :agendas, :tipo, :string
  end
end
