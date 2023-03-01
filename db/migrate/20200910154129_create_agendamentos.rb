class CreateAgendamentos < ActiveRecord::Migration[5.2]
  def change
    create_table :agendamentos do |t|
      t.date :data_inicio
      t.date :data_fim
      t.time :hora_inicio
      t.time :hora_fim
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
