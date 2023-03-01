class Usuario < ApplicationRecord  
    has_secure_password
    
    has_many :tipo_vinculos, dependent: :destroy
    
    has_many :inscricaos, :class_name => 'Inscricao', dependent: :destroy
    has_many :agendas, :through => :inscricaos

    has_many :permissaos, :class_name => 'Permissao', dependent: :destroy
    has_many :perfils, :through => :permissaos

    has_many :permissaos, :class_name => 'Permissao', dependent: :destroy
    has_many :salas, :through => :permissaos

end
