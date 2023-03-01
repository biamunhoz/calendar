class AddUsertipoToAgendas < ActiveRecord::Migration[5.2]
  def change
    add_column :inscricaos, :usertipo, :string
  end
end
