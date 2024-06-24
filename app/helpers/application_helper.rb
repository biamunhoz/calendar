module ApplicationHelper

    def carregarsalas

        @salas = carrega_salas

        salaspermitidas = Array.new

        @salas.each do |a|
            salaspermitidas << a.id
        end

        return salaspermitidas
    end

    def teminscricao(agendaid)
        @inscricao = Inscricao.joins(:usuario).joins(:agenda).where("usuarios.loginUsuario = ? and agenda_id = ? ", session[:login], agendaid)
        .select("usertipo, agenda_id, inscricaos.tipo")
    end 

    def infoagenda(agendaid)
        @dadosagenda = Agenda.find_by(:id => agendaid)        
    end 
  
   
end
