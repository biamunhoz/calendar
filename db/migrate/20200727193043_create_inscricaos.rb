class CreateInscricaos < ActiveRecord::Migration[5.2]
  def change
    create_table :inscricaos do |t|
      t.references :usuario, foreign_key: true
      t.references :agenda, foreign_key: true

      t.timestamps
    end
  end
end
