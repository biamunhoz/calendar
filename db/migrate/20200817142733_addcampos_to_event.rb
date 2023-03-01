class AddcamposToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :descricao, :string
    add_column :events, :domingo, :boolean 
    add_column :events, :segunda, :boolean
    add_column :events, :terca, :boolean
    add_column :events, :quarta, :boolean
    add_column :events, :quinta, :boolean
    add_column :events, :sexta, :boolean
    add_column :events, :sabado, :boolean
    add_column :events, :pendente, :boolean
    add_column :events, :registropara, :string
    add_column :events, :sala_id , :integer, :references => "sala"
    add_column :events, :usuario_id, :integer, :references => "usuario"
  end
end
