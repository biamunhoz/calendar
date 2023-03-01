class AddTipoToInscricao < ActiveRecord::Migration[5.2]
  def change
    add_column :inscricaos, :tipo, :string
  end
end
