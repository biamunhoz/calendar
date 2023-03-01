module ApplicationHelper

    def carregarsalas

        @salas = carrega_salas

        salaspermitidas = Array.new

        @salas.each do |a|
            salaspermitidas << a.id
        end

        return salaspermitidas
    end
   
end
