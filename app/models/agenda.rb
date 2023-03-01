class Agenda < ApplicationRecord
    has_many :salas

    has_many :inscricaos, :class_name => 'Inscricao', dependent: :delete_all
    has_many :usuarios, :through => :inscricaos

end
