class CreateAgendas < ActiveRecord::Migration[5.2]
  def change
    create_table :agendas do |t|
      t.string :nome
      t.boolean :apresentacaotelaini
      t.string :observacao

      t.timestamps
    end
  end
end
