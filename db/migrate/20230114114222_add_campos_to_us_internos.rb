class AddCamposToUsInternos < ActiveRecord::Migration[5.2]
  def change
    add_column :usuarios, :cpf, :string
    add_column :usuarios, :endereco, :string
    add_column :usuarios, :tel_contato, :string
    add_column :usuarios, :password_digest, :string
  end
end
