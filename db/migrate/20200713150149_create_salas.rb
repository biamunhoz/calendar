class CreateSalas < ActiveRecord::Migration[5.2]
  def change
    create_table :salas do |t|
      t.string :nome
      t.string :cor
      t.boolean :permissaoauto
      t.text :observacao
      t.boolean :confirmacao
      t.references :agendas, foreign_key: true

      t.timestamps
    end
  end
end
