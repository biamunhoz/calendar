class Permissao < ApplicationRecord
  belongs_to :usuario
  belongs_to :sala
  belongs_to :perfil
end
