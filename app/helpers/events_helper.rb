module EventsHelper

    def extrair_primeiro_nome(nome_completo)
        # Divida o nome completo em palavras usando o espaço como delimitador
        palavras = nome_completo.split
        
        # O primeiro nome é a primeira palavra da lista
        primeiro_nome = palavras.first
        
        return primeiro_nome
    end

    def mostraanonimo(salaid)

        @sala = Sala.find(salaid)

        return @sala.anonimo
    end 

end
