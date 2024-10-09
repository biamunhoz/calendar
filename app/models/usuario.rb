class Usuario < ApplicationRecord  
    has_secure_password
    
    has_many :tipo_vinculos, dependent: :destroy
    
    has_many :inscricaos, :class_name => 'Inscricao', dependent: :destroy
    has_many :agendas, :through => :inscricaos

    has_many :permissaos, :class_name => 'Permissao', dependent: :destroy
    has_many :perfils, :through => :permissaos

    has_many :permissaos, :class_name => 'Permissao', dependent: :destroy
    has_many :salas, :through => :permissaos

    has_many :events

    validates :emailPrincipalUsuario, uniqueness: {message: "E-mail já cadastrado anteriormente" }
    
    validate :email_valido?
    validate :check_cpf 
    validate :nome
    validate :telefone

    def nome

        nomeparavalidar = self.nomeUsuario

        if self.tipoUsuario == "EXTERNO"

            if nomeparavalidar == ""
                errors.add(:nomeUsuario, "Nome está vazio")
                return false 
            else
                return true
            end 
        end
    end 

    def telefone

        telefoneparavalidar = self.numeroTelefoneFormatado


        if self.tipoUsuario == "EXTERNO"
 
            if telefoneparavalidar == ""
                errors.add(:numeroTelefoneFormatado, "Telefone está vazio")
                return false 
            else 
                return true
            end 
        end
    end 

    def email_valido?

        emailparavalidar = self.emailPrincipalUsuario
        
        if self.tipoUsuario == "EXTERNO"
            # Definir a expressão regular para validar o e-mail
            regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
            
            # Verificar se o e-mail corresponde à expressão regular
            if emailparavalidar =~ regex
                return true
            else
                errors.add(:emailPrincipalUsuario, "E-mail inválido")
                return false 
            end
        else
            return true
        end 
    end

    def check_cpf

        if self.tipoUsuario == "EXTERNO"

            nulos = %w{12345678909 11111111111 22222222222 33333333333 44444444444 55555555555 66666666666 77777777777 88888888888 99999999999 00000000000 12345678909}
            valor = self.cpf.scan /[0-9]/
            if valor.length == 11
                unless nulos.member?(valor.join)
                    valor = valor.collect{|x| x.to_i}
                    soma = 10*valor[0]+9*valor[1]+8*valor[2]+7*valor[3]+6*valor[4]+5*valor[5]+4*valor[6]+3*valor[7]+2*valor[8]
                    soma = soma - (11 * (soma/11))
                    resultado1 = (soma == 0 or soma == 1) ? 0 : 11 - soma
                    if resultado1 == valor[9]
                        soma = valor[0]*11+valor[1]*10+valor[2]*9+valor[3]*8+valor[4]*7+valor[5]*6+valor[6]*5+valor[7]*4+valor[8]*3+valor[9]*2
                        soma = soma - (11 * (soma/11))
                        resultado2 = (soma == 0 or soma == 1) ? 0 : 11 - soma
                        return true if resultado2 == valor[10]  # CPF válido   
                    end
                end
            end

            errors.add(:cpf, "CPF inválido")
            return false # CPF inválido
        else
            return true
        end 
        
    end

end
