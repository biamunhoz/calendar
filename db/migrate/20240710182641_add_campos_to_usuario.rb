class AddCamposToUsuario < ActiveRecord::Migration[5.2]
  def change
    add_column :usuarios, :instituicao, :string
    add_column :usuarios, :vinculo, :string
  end
end
