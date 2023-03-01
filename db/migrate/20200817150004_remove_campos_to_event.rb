class RemoveCamposToEvent < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :string
    remove_column :events, :body
  end
end
