class Event < ApplicationRecord
    has_many :agendamentos, dependent: :delete_all
    belongs_to :sala
    belongs_to :usuario
    validates_presence_of :sala_id, message: "Campo obrigatório"
    validate :horariomarcado
    validate :tempolimite
    validate :dia_is_checked
    validate :ehfds

    def ehfds

      @configsala = Sala.find(self.sala_id)

      if @configsala.disablefds == true

        self.start_date.to_date.upto(self.end_date.to_date) do |day|

          case day.wday       
          when 0
            if self.domingo == true
              print "Domingo - Fim de semanaaaaaaaaaaaaaaaaaaaaaaa"
              errors.add(:sala_id, "Impossível marcar no fim de semana")
              break
            end 
          when 6
            if self.sabado == true
              print "Sabado - Fim de semanaaaaaaaaaaaaaaaaaaaaaaa"
              errors.add(:sala_id, "Impossível marcar no fim de semana")
              break              
            end 
          end 
        end 
      end

    end 


    def dia_is_checked
      errors.add(:base, "Por favor, selecione pelo menos um dia.") unless domingo || segunda || terca || quarta || quinta || sexta || sabado
    end

    def tempolimite
      
      if self.sala_id == nil
        errors.add(:sala, "Evento não pode ser marcado. Por favor, escolha uma sala")  
      else 
        @sala = Sala.find_by(id: self.sala_id)

        @ehadmindasala = Sala.joins(:permissaos).find_by(" permissaos.perfil_id in (1,2) and permissaos.usuario_id = ? and salas.id = ? ", self.usuario_id, self.sala_id)

        if @ehadmindasala.nil?
          
          valorlimite = 0

          if  @sala.limiteqtdeuso == true
            valorlimite = @sala.limitehoras
    
            valorlimite = valorlimite * 60
    
            horaini = (self.timeini.hour * 60) + self.timeini.min
            horafim = (self.timefim.hour * 60) + self.timefim.min
    
            tempo = horafim - horaini
    
            if tempo > valorlimite
              errors.add(:Data_Final, "Evento não pode ser marcado. Há um limite de tempo definido, favor agendar com no máximo " + valorlimite.to_s + " minutos de uso por dia.")
            end
            
            #tem outros registros ao longo do dia?
            tempototal = tempo 
  
            @outroseventos = Event.where(sala_id: self.sala_id).where(" desmarcado = false and start_date = ? or end_date = ? and usuario_id = ?" , self.start_date, self.end_date, self.usuario_id)
  
            @outroseventos.each do |outroevent|
  
              horaini = (outroevent.timeini.hour * 60) + outroevent.timeini.min
              horafim = (outroevent.timefim.hour * 60) + outroevent.timefim.min
              
              tempo = horafim - horaini
  
              tempototal = tempototal + tempo 
            end
  
            if tempototal > valorlimite
              errors.add(:Data_Final, "Evento não pode ser marcado. Há um limite de tempo definido, favor agendar com no máximo " + valorlimite.to_s + " minutos de uso por dia.")
            end
  
          end

        end 
        
      end

    end

    def horariomarcado
      if validaFinal == true
        errors.add(:aviso1, "Ou esse período já foi reservado anteriormente.")
        errors.add(:aviso2, "Ou período não permite reserva .")
        errors.add(:aviso3, "Ou dia da semana marcado pode ser diferente do que o dia real.")
      end  
    end

    def validaFinal
    
      bAchou = false
      
      @horaini = self.timeini
      @horafim = self.timefim
  

      if new_record?
        @eventosdasala = Event.where(sala_id: self.sala_id).where(" desmarcado = false and start_date >= ? or end_date >= ? " , self.start_date, self.end_date)
      else
        @eventosdasala = Event.where(sala_id: self.sala_id).where(" desmarcado = false and start_date >= ? or end_date >= ? " , self.start_date, self.end_date).where.not(id: self.id )
      end  

      ids = Array.new
      @eventosdasala.each do |e|
        ids << e.id
      end

      @configsala = Sala.find(self.sala_id)
  
      if !ids.empty?
      
        @agendacad = Agendamento.where(" event_id in (?) ", ids)
  
        diaini = self.start_date.to_date
        diafim = self.end_date.to_date
  
        diaini.upto(diafim) do |day|

          print "Cheguei aquiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii"

          case day.wday       
            when 0
              if self.domingo == true
                if @configsala.disablefds == true
                  bAchou = true
                  break
                  if verificaTempo(day, @horaini, @horafim) 
                    bAchou = true
                    break
                  end

                end 
              else 
                bAchou = true
                break
              end    
            when 1
              if self.segunda == true

                if feriado(day)
                  bAchou = true
                  break
                end

                if verificaTempo(day, @horaini, @horafim)
                  bAchou = true
                  break
                end
              else 
                bAchou = true
                break                              
              end 
            when 2
              if self.terca == true

                if feriado(day)
                  bAchou = true
                  break
                end

                if verificaTempo(day, @horaini, @horafim) 
                  bAchou = true
                  break
                end
              else 
                bAchou = true
                break                 
              end 
            when 3
              if self.quarta == true
                if feriado(day)
                  bAchou = true
                  break
                end

                if verificaTempo(day, @horaini, @horafim)
                  bAchou = true
                  break
                end 
              else 
                bAchou = true
                break                 
              end 
            when 4

              if self.quinta == true
                if feriado(day)
                  bAchou = true
                  break
                end

                if verificaTempo(day, @horaini, @horafim)
                  bAchou = true
                  break
                end
              else 
                bAchou = true
                break                 
              end
            when 5
              if self.sexta == true
                if feriado(day)
                  bAchou = true
                  break
                end

                if verificaTempo(day, @horaini, @horafim) 
                  bAchou = true              
                  break
                end 
              else 
                bAchou = true
                break                 
              end 
            when 6
              if self.sabado == true
                if @configsala.disablefds == true
                  bAchou = true
                  break
                  if verificaTempo(day, @horaini, @horafim)
                    bAchou = true
                    break
                  end
                end 
              else 
                bAchou = true
                break 
              end  
            end
        end  
      end 
  
      return bAchou
  
    end

    def feriado(dia)
      
      bAchou = false

      case dia.month      
      when 1
        if dia.day == 1 or dia.day == 25
          bAchou = true
        end 
      when 4
        if dia.day == 21
          bAchou = true
        end 
      when 5
        if dia.day == 1 
          bAchou = true
        end 
      when 7
        if dia.day == 9
          bAchou = true
        end 
      when 9
        if dia.day == 7
          bAchou = true
        end 
      when 10
        if dia.day == 12
          bAchou = true
        end 
      when 11
        if dia.day == 2 or dia.day == 15 or dia.day == 20
          bAchou = true
        end 
      when 12
        if dia.day == 25
          bAchou = true
        end 
      end 

      
    end

    def verificaTempo(dia, horaini, horafim)

      bAchou = false
  
      horanewini = horaini.to_time.strftime("%H:%M")
      horanewfim = horafim.to_time.strftime("%H:%M")
  
      @agendacad.each do |a|
        if a.data_inicio == dia
  
          horacadini = a.hora_inicio.to_time.strftime("%H:%M")
          horacadfim = a.hora_fim.to_time.strftime("%H:%M")
          
          print "HORA INICIO JA AGENDADA ===>"
          print horacadini
          print "HORA INICIO DA FUNCAO ===>"
          print horanewini
  
          if horacadini == horanewini or horacadfim == horanewfim 
            print "===================================="
            bAchou = true
          end
          if horacadini > horanewini and horacadini < horanewfim 
            print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
            bAchou = true
          end
          if horacadini < horanewini and horacadfim > horanewini
            print "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            bAchou = true
          end  
  
        end    
  
      end
  
      return bAchou
  
    end

end

