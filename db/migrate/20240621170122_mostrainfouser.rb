class Mostrainfouser < ActiveRecord::Migration[5.2]
  def change
    add_column :agendas, :mostrainfouser, :boolean, :default => false
  end
end
