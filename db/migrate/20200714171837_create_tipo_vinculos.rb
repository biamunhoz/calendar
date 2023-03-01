class CreateTipoVinculos < ActiveRecord::Migration[5.2]
  def change
    create_table :tipo_vinculos do |t|
      t.string :tipoVinculo
      t.string :codigoSetor
      t.string :nomeAbreviadSetor
      t.string :nomeSetor
      t.string :codigoUnidade
      t.string :siglaUnidade
      t.string :nomeUnidade
      t.string :nomeVinculo
      t.string :nomeAbreviadoFuncao
      t.references :usuario, foreign_key: true

      t.timestamps
    end
  end
end
