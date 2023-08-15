class AddGoogleformsToAgenda < ActiveRecord::Migration[5.2]
  def change
    add_column :agendas, :reservadoformextra, :string
  end
end
