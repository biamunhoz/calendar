class Inscricao < ApplicationRecord
  belongs_to :usuario
  belongs_to :agenda
end
