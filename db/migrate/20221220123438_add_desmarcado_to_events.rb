class AddDesmarcadoToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :desmarcado, :boolean, :default => false
  end
end
