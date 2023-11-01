module SalasHelper

    def tempermissaosuperadmin(sala_id)

        @valor = Sala.joins(:permissaos).where(id: sala_id).where(" permissaos.perfil_id in (1,2) and permissaos.usuario_id = ? ", current_user.id)

        return @valor.exists?

    end

    def jasolicitouacesso(sala_id)

        @valor = Sala.joins(:permissaos).where(id: sala_id).where(" permissaos.perfil_id = 4 and permissaos.usuario_id = ? ", current_user.id)

        return @valor.exists?

    end

end
