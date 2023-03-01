class AddCamposToSalas < ActiveRecord::Migration[5.2]
  def change
    add_column :salas, :avisoadmhoravaga, :boolean, :default => false
    add_column :salas, :limiteqtdeuso, :boolean, :default => false
    add_column :salas, :limitehoras, :integer
  end
end
