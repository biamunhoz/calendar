class Perfil < ApplicationRecord

    has_many :permissaos, :class_name => 'Permissao'
    has_many :salas, :through => :permissaos
  
    has_many :permissaos, :class_name => 'Permissao'
    has_many :usuarios, :through => :permissaos
end
