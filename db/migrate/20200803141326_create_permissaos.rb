class CreatePermissaos < ActiveRecord::Migration[5.2]
  def change
    create_table :permissaos do |t|
      t.references :usuario, foreign_key: true
      t.references :sala, foreign_key: true
      t.references :perfil, foreign_key: true

      t.timestamps
    end
  end
end
